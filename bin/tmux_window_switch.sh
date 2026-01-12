#!/usr/bin/env bash
# Window switcher excluding archived sessions

windows=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue
  while IFS= read -r window; do
    windows+="$window"$'\n'
  done < <(tmux list-windows -t "$session" -F "#S:#I: #W")
done < <(tmux list-sessions -F '#S')

[[ -z "$windows" ]] && exit 0

selected=$(echo -n "$windows" | fzf-tmux -p -w 60% -h 50% --reverse)
[[ -z "$selected" ]] && exit 0

target=$(echo "$selected" | cut -d: -f1-2)
tmux switch-client -t "$target"
