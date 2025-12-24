#!/usr/bin/env bash
# Show fzf popup of all tmux windows with pending AI sessions

pending=$(tmux list-windows -a -F \
  '#{?#{==:#{@claude_waiting},1},#{session_name}:#{window_index}: #{window_name},}' \
  | grep -v '^$')

if [[ -z "$pending" ]]; then
  tmux display-message "No pending sessions"
  exit 0
fi

selected=$(echo "$pending" | fzf-tmux -p -w 50% -h 50% \
  --header="Pending Sessions" \
  --no-multi \
  --reverse)

[[ -z "$selected" ]] && exit 0

target=$(echo "$selected" | sed 's/: .*//')
session=$(echo "$target" | cut -d: -f1)
window=$(echo "$target" | cut -d: -f2)

tmux switch-client -t "$session"
tmux select-window -t "$session:$window"
