#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')

output=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue

  if [[ "$session" == "$current_session" ]]; then
    output+="#[bg=colour4,fg=colour0,bold] ${session} #[default]"
  else
    output+="#[fg=colour8] ${session} #[default]"
  fi
done < <(tmux list-sessions -F '#S' 2>/dev/null)

echo "$output"
