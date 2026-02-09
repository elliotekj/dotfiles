#!/usr/bin/env bash
# Window switcher with Claude state icons, grouped by session
# Designed to run INSIDE tmux display-popup -E

CACHE_DIR="$HOME/.cache/tmux-claude-status"
MUTED='\033[38;2;144;140;170m'
GOLD='\033[38;2;246;193;119m'
ROSE='\033[38;2;235;188;186m'
FOAM='\033[38;2;156;207;216m'
RESET='\033[0m'
MAX_BRANCH=24

relative_time() {
  local ts=$1 now diff
  now=$(date +%s)
  diff=$(( now - ts ))

  if (( diff < 60 )); then
    echo "just now"
  elif (( diff < 120 )); then
    echo "1 min ago"
  elif (( diff < 3600 )); then
    echo "$(( diff / 60 )) min ago"
  elif (( diff < 7200 )); then
    echo "1 hr ago"
  else
    echo "$(( diff / 3600 )) hr ago"
  fi
}

truncate_branch() {
  local b=$1
  if (( ${#b} > MAX_BRANCH )); then
    echo "${b:0:$((MAX_BRANCH - 1))}…"
  else
    echo "$b"
  fi
}

state_sort_key() {
  case "$1" in
    waiting) echo 0 ;;
    working) echo 1 ;;
    done)    echo 2 ;;
    *)       echo 3 ;;
  esac
}

state_icon() {
  case "$1" in
    working) printf "${GOLD}◑${RESET}" ;;
    waiting) printf "${ROSE}○${RESET}" ;;
    done)    printf "${FOAM}●${RESET}" ;;
    *)       printf " " ;;
  esac
}

# Collect window data per session
declare -A active_windows
declare -A active_panes
declare -A session_windows
max_session=0
max_wname=0
max_branch=0

active_sessions=()
while IFS= read -r s; do
  archived=$(tmux show-option -t "$s" -qv @archived 2>/dev/null)
  [[ "$archived" == "1" ]] && continue
  active_sessions+=("$s")
done < <(tmux list-sessions -F '#S' 2>/dev/null)

# Build set of active panes for cache pruning
while IFS=$'\t' read -r ps pw pp; do
  pp="${pp#%}"
  active_panes["$ps/$pw/$pp"]=1
done < <(tmux list-panes -a -F '#{session_name}'$'\t''#{window_index}'$'\t''#{pane_id}' 2>/dev/null)

for s in "${active_sessions[@]}"; do
  while IFS=$'\t' read -r idx wname; do
    active_windows["$s/$idx"]=1
    cache_dir="$CACHE_DIR/$s/$idx"

    # Aggregate state across all panes in this window
    state="" branch="" timestamp="" time_str=""
    if [[ -d "$cache_dir" ]]; then
      best_sk=3
      for pane_file in "$cache_dir"/*; do
        [[ -f "$pane_file" ]] || continue
        p_state="" p_branch="" p_timestamp=""
        while IFS='=' read -r key val; do
          case "$key" in
            state) p_state="$val" ;;
            branch) p_branch="$val" ;;
            timestamp) p_timestamp="$val" ;;
          esac
        done < "$pane_file"
        p_sk=$(state_sort_key "$p_state")
        if (( p_sk < best_sk )); then
          best_sk=$p_sk
          state="$p_state"
          branch="$p_branch"
          timestamp="$p_timestamp"
        fi
      done
    fi
    [[ -n "$branch" ]] && branch=$(truncate_branch "$branch")
    [[ -n "$timestamp" ]] && time_str=$(relative_time "$timestamp")

    sk=$(state_sort_key "$state")
    entry="${sk}\t${idx}\t${wname}\t${state}\t${branch}\t${time_str}"

    if [[ -n "${session_windows[$s]}" ]]; then
      session_windows[$s]+=$'\n'"$entry"
    else
      session_windows[$s]="$entry"
    fi

    (( ${#s} > max_session )) && max_session=${#s}
    (( ${#wname} > max_wname )) && max_wname=${#wname}
    (( ${#branch} > max_branch )) && max_branch=${#branch}
  done < <(tmux list-windows -t "$s" -F '#{window_index}'$'\t''#W' 2>/dev/null)
done

# Prune stale cache entries
if [[ -d "$CACHE_DIR" ]]; then
  for session_dir in "$CACHE_DIR"/*/; do
    [[ -d "$session_dir" ]] || continue
    sname=$(basename "$session_dir")
    for window_dir in "$session_dir"*/; do
      [[ -d "$window_dir" ]] || continue
      widx=$(basename "$window_dir")
      if [[ -z "${active_windows["$sname/$widx"]}" ]]; then
        rm -rf "$window_dir"
      else
        for pf in "$window_dir"*; do
          [[ -f "$pf" ]] || continue
          pid=$(basename "$pf")
          [[ -z "${active_panes["$sname/$widx/$pid"]}" ]] && rm -f "$pf"
        done
        rmdir "$window_dir" 2>/dev/null || true
      fi
    done
    rmdir "$session_dir" 2>/dev/null || true
  done
fi

[[ ${#active_sessions[@]} -eq 0 ]] && exit 0

# Build display lines grouped by session
declare -a display_lines targets

for s in "${active_sessions[@]}"; do
  [[ -z "${session_windows[$s]}" ]] && continue

  # Session header
  display_lines+=("${MUTED}${s}${RESET}")
  targets+=("$s")

  # Sort windows within session
  sorted_entries=$(echo -e "${session_windows[$s]}" | sort -t$'\t' -k1,1)

  while IFS=$'\t' read -r _sk idx wname state branch time_str; do
    icon=$(state_icon "$state")

    pad_wname=$(( max_wname - ${#wname} ))
    wname_padded="${wname}$(printf '%*s' "$pad_wname" '')"

    if [[ -n "$branch" || -n "$time_str" ]]; then
      pad_branch=$(( max_branch - ${#branch} ))
      branch_padded="${branch}$(printf '%*s' "$pad_branch" '')"
      line="${icon} ${wname_padded}  ${MUTED}${branch_padded}  ${time_str}${RESET}"
    else
      line="${icon} ${wname_padded}"
    fi

    display_lines+=("$line")
    targets+=("$s:$idx")
  done <<< "$sorted_entries"
done

[[ ${#display_lines[@]} -eq 0 ]] && exit 0

selected=$(printf '%b\n' "${display_lines[@]}" | gum filter --no-strip-ansi --no-show-help --placeholder 'Switch window...' --height 40 --strict)
[[ -z "$selected" ]] && exit 0

# Strip ANSI codes and match to target
clean_selected=$(echo "$selected" | sed $'s/\033\[[0-9;]*m//g')

target=""
for i in "${!display_lines[@]}"; do
  [[ -z "${targets[$i]}" ]] && continue
  clean_display=$(printf '%b' "${display_lines[$i]}" | sed $'s/\033\[[0-9;]*m//g')
  if [[ "$clean_display" == "$clean_selected" ]]; then
    target="${targets[$i]}"
    break
  fi
done

[[ -z "$target" ]] && exit 0

tmux switch-client -t "$target"
