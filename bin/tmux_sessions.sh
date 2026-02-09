#!/usr/bin/env bash

CACHE_DIR="$HOME/.cache/tmux-claude-status"
current_session=$(tmux display-message -p '#S')

session_worst_state() {
  local session="$1"
  local dir="$CACHE_DIR/$session"
  [[ -d "$dir" ]] || return

  local worst=""
  for f in "$dir"/*; do
    [[ -f "$f" ]] || continue
    local state=""
    while IFS='=' read -r key val; do
      [[ "$key" == "state" ]] && state="$val"
    done < "$f"

    case "$state" in
      waiting) echo "waiting"; return ;;
      working) worst="working" ;;
      done)    [[ -z "$worst" ]] && worst="done" ;;
    esac
  done

  [[ -n "$worst" ]] && echo "$worst"
}

state_icon_tmux() {
  case "$1" in
    working) echo "#[fg=#f6c177]◑#[fg=default]" ;;
    waiting) echo "#[fg=#ebbcba]○#[fg=default]" ;;
    done)    echo "#[fg=#9ccfd8]●#[fg=default]" ;;
  esac
}

output=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue

  worst=$(session_worst_state "$session")
  icon=""
  [[ -n "$worst" ]] && icon="$(state_icon_tmux "$worst") "

  if [[ "$session" == "$current_session" ]]; then
    output+="#[bg=#ebbcba,fg=#191724,bold] ${icon}${session} #[bg=#191724,fg=#e0def4,nobold]"
  else
    output+="#[bg=#191724,fg=#908caa] ${icon}${session} #[bg=#191724]"
  fi
done < <(tmux list-sessions -F '#S' 2>/dev/null)

echo "$output"
