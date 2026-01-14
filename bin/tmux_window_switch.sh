#!/usr/bin/env bash
# Window switcher excluding archived sessions
# Shows Claude state icons: 👾 (running), 🛑 (waiting), ❓ (asking)

windows=""
while IFS= read -r session; do
  archived=$(tmux show-option -t "$session" -qv @archived)
  [[ "$archived" == "1" ]] && continue
  while IFS= read -r line; do
    index=$(echo "$line" | cut -d: -f2)
    state=$(tmux show-option -wt "$session:$index" -qv @claude_state)

    case "$state" in
      running)
        windows+="\033[38;5;216m👾 ${line}\033[0m"$'\n'
        ;;
      waiting)
        windows+="\033[38;5;216m🛑 ${line}\033[0m"$'\n'
        ;;
      asking)
        windows+="\033[38;5;216m❓ ${line}\033[0m"$'\n'
        ;;
      *)
        windows+="   $line"$'\n'
        ;;
    esac
  done < <(tmux list-windows -t "$session" -F "#S:#I: #W")
done < <(tmux list-sessions -F '#S')

[[ -z "$windows" ]] && exit 0

selected=$(echo -en "$windows" | fzf-tmux -p -w 60% -h 50% --reverse --ansi)
[[ -z "$selected" ]] && exit 0

# Strip icon prefix when extracting target
target=$(echo "$selected" | sed 's/^[👾🛑❓ ]*//' | cut -d: -f1-2)
tmux switch-client -t "$target"
