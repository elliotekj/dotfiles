#!/usr/bin/env bash
set -o pipefail
trap 'exit 0' ERR

CACHE_DIR="$HOME/.cache/tmux-claude-status"

input=$(cat)

hook_event=$(echo "$input" | jq -r '.hook_event_name // empty') || exit 0
[[ -z "$hook_event" ]] && exit 0

cwd=$(echo "$input" | jq -r '.cwd // empty') || true

if [[ -n "$TMUX_PANE" ]]; then
  session=$(tmux display-message -t "$TMUX_PANE" -p '#{session_name}' 2>/dev/null) || exit 0
  window=$(tmux display-message -t "$TMUX_PANE" -p '#{window_index}' 2>/dev/null) || exit 0
else
  my_pid=$$
  target_pid=$my_pid
  pane_list=$(tmux list-panes -a -F '#{pane_pid} #{session_name} #{window_index}' 2>/dev/null) || exit 0

  session=""
  window=""
  while [[ -n "$target_pid" && "$target_pid" != "0" && "$target_pid" != "1" ]]; do
    match=$(echo "$pane_list" | awk -v pid="$target_pid" '$1 == pid { print $2, $3; exit }')
    if [[ -n "$match" ]]; then
      session=$(echo "$match" | cut -d' ' -f1)
      window=$(echo "$match" | cut -d' ' -f2)
      break
    fi
    target_pid=$(ps -o ppid= -p "$target_pid" 2>/dev/null | tr -d ' ')
  done

  [[ -z "$session" || -z "$window" ]] && exit 0
fi

cache_file="$CACHE_DIR/$session/$window"

if [[ "$hook_event" == "SessionEnd" ]]; then
  rm -rf "$CACHE_DIR/$session"
  exit 0
fi

case "$hook_event" in
  PreToolUse)  state="working" ;;
  Stop)        state="done" ;;
  Notification) state="waiting" ;;
  *)           exit 0 ;;
esac

branch=""
if [[ -n "$cwd" ]]; then
  branch=$(git -C "$cwd" symbolic-ref --short HEAD 2>/dev/null) || true
fi

mkdir -p "$CACHE_DIR/$session"
printf 'state=%s\nbranch=%s\ntimestamp=%s\n' "$state" "$branch" "$(date +%s)" > "$cache_file"
