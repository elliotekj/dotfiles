#!/usr/bin/env bash
# Commands palette for tmux session management

commands="New session\nRename session"

selected=$(echo -e "$commands" | fzf-tmux -p -w 40% -h 30% \
  --header="Commands" \
  --no-multi \
  --reverse)

[[ -z "$selected" ]] && exit 0

case "$selected" in
  "New session")
    name=$(echo "" | fzf-tmux -p -w 40% -h 20% \
      --header="Session name:" \
      --print-query \
      --no-info | head -1)
    [[ -z "$name" ]] && exit 0
    tmux new-session -d -s "$name"
    tmux switch-client -t "$name"
    ;;
  "Rename session")
    current=$(tmux display-message -p '#S')
    name=$(echo "" | fzf-tmux -p -w 40% -h 20% \
      --header="Rename '$current' to:" \
      --print-query \
      --no-info | head -1)
    [[ -z "$name" ]] && exit 0
    tmux rename-session "$name"
    ;;
esac
