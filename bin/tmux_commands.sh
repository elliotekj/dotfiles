#!/usr/bin/env bash
# Commands palette for tmux session management

commands="Archive session\nFiles\nGit\nGitHub\nHtop\nKill session\nMail\nNew session\nQuick Claude\nRename session\nRestore session"

selected=$(echo -e "$commands" | fzf-tmux -p -w 40% -h 30% \
  --header="Commands" \
  --no-multi \
  --reverse)

[[ -z "$selected" ]] && exit 0

case "$selected" in
  "Archive session")
    current=$(tmux display-message -p '#S')
    # Find next non-archived session to switch to
    next=$(tmux list-sessions -F '#S' | while read -r s; do
      [[ "$s" == "$current" ]] && continue
      [[ $(tmux show-option -t "$s" -qv @archived) != "1" ]] && echo "$s" && break
    done)
    if [[ -z "$next" ]]; then
      tmux display-message "Cannot archive: no other sessions available"
      exit 0
    fi
    tmux set-option -t "$current" @archived 1
    tmux switch-client -t "$next"
    ;;
  "Files")
    dir=$(tmux display-message -p '#{pane_current_path}')
    tmux display-popup -w 80% -h 80% -d "$dir" -E yazi
    ;;
  "Git")
    dir=$(tmux display-message -p '#{pane_current_path}')
    tmux display-popup -w 80% -h 80% -d "$dir" -E gitu
    ;;
  "GitHub")
    dir=$(tmux display-message -p '#{pane_current_path}')
    tmux display-popup -w 80% -h 80% -d "$dir" -E gh dash
    ;;
  "Htop")
    tmux display-popup -w 80% -h 80% -E htop
    ;;
  "Kill session")
    current=$(tmux display-message -p '#S')
    next=$(tmux list-sessions -F '#S' | while read -r s; do
      [[ "$s" == "$current" ]] && continue
      [[ $(tmux show-option -t "$s" -qv @archived) != "1" ]] && echo "$s" && break
    done)
    if [[ -z "$next" ]]; then
      tmux display-message "Cannot kill: no other sessions available"
      exit 0
    fi
    tmux switch-client -t "$next"
    tmux kill-session -t "$current"
    ;;
  "Mail")
    tmux display-popup -w 80% -h 80% -E mai
    ;;
  "New session")
    name=$(echo "" | fzf-tmux -p -w 40% -h 20% \
      --header="Session name:" \
      --print-query \
      --no-info | head -1)
    [[ -z "$name" ]] && exit 0
    tmux new-session -d -s "$name"
    tmux switch-client -t "$name"
    ;;
  "Quick Claude")
    dir=$(tmux display-message -p '#{pane_current_path}')
    node_version=$(mise current -C ~ node)
    tmux display-popup -w 80% -h 80% -d "$dir" -E "mise x node@$node_version -- claude --dangerously-skip-permissions --model haiku"
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
  "Restore session")
    archived=$(tmux list-sessions -F '#S' | while read -r s; do
      [[ $(tmux show-option -t "$s" -qv @archived) == "1" ]] && echo "$s"
    done)
    if [[ -z "$archived" ]]; then
      tmux display-message "No archived sessions"
      exit 0
    fi
    selected=$(echo "$archived" | fzf-tmux -p -w 40% -h 30% \
      --header="Restore session:" \
      --no-multi \
      --reverse)
    [[ -z "$selected" ]] && exit 0
    tmux set-option -t "$selected" @archived 0
    tmux switch-client -t "$selected"
    ;;
esac
