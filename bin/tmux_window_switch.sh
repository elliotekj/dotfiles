#!/usr/bin/env bash
# Window switcher excluding archived sessions

windows=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue
  while IFS= read -r line; do
    index=$(echo "$line" | cut -d: -f2)
    waiting=$(tmux show-option -wt "$session:$index" -qv @claude_waiting)
    if [[ "$waiting" == "1" ]]; then
      windows+="\033[38;5;216m${line}\033[0m"$'\n'
    else
      windows+="$line"$'\n'
    fi
  done < <(tmux list-windows -t "$session" -F "#S:#I: #W")
done < <(tmux list-sessions -F '#S')

[[ -z "$windows" ]] && exit 0

selected=$(echo -en "$windows" | fzf-tmux -p -w 60% -h 50% --reverse --ansi)
[[ -z "$selected" ]] && exit 0

target=$(echo "$selected" | cut -d: -f1-2)
tmux switch-client -t "$target"
