#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')

output=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue

  if [[ "$session" == "$current_session" ]]; then
    output+="#[bg=#ebbcba,fg=#191724,bold] ${session} #[bg=#191724,fg=#e0def4,nobold]"
  else
    output+="#[bg=#191724,fg=#908caa] ${session} #[bg=#191724]"
  fi
done < <(tmux list-sessions -F '#S' 2>/dev/null)

echo "$output"
