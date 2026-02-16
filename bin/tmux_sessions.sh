#!/usr/bin/env bash

current_session=$(tmux display-message -p '#S')

output=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue

  if [[ "$session" == "$current_session" ]]; then
    output+="#[bg=#bd93f9,fg=#282a36,bold] ${session} #[bg=#282a36,fg=#f8f8f2,nobold]"
  else
    output+="#[bg=#282a36,fg=#6272a4] ${session} #[bg=#282a36]"
  fi
done < <(tmux list-sessions -F '#S' 2>/dev/null)

echo "$output"
