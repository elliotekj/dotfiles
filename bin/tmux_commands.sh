#!/usr/bin/env bash
# Commands palette for tmux session management

# Base commands
commands="Archive session\nCheckout Worktree\nFiles\nGit\nGitHub\nHtop\nKill session\nLayout: horizontal\nLayout: vertical\nMail\nMerge Worktree\nNew session\nPane: main left\nPane: main right\nQuick Claude\nRemove Worktree\nRename session\nRestore session\nSend keybinding to all panes\nSend to all panes"

# Add option to kick SSH clients when local and other clients are attached
if [[ -z "$SSH_CONNECTION" ]] && [ "$(tmux list-clients | wc -l | tr -d ' ')" -gt 1 ]; then
  commands="$commands\nKick SSH clients"
fi

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
  "Checkout Worktree")
    dir=$(tmux display-message -p '#{pane_current_path}')
    result=$(git -C "$dir" branch --format='%(refname:short)' 2>/dev/null | \
      fzf-tmux -p -w 40% -h 30% \
        --header="Select branch or type new name:" \
        --print-query \
        --no-info \
        --reverse)
    query=$(echo "$result" | sed -n '1p')
    selection=$(echo "$result" | sed -n '2p')
    name="${selection:-$query}"
    [[ -z "$name" ]] && exit 0
    if git -C "$dir" worktree list --porcelain | grep -q "^branch refs/heads/$name$"; then
      tmux send-keys "wt switch '$name'" Enter
    else
      tmux send-keys "wt switch --create '$name'" Enter
    fi
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
  "Layout: horizontal")
    tmux select-layout even-horizontal
    ;;
  "Layout: vertical")
    tmux select-layout even-vertical
    ;;
  "Mail")
    tmux display-popup -w 80% -h 80% -E mai
    ;;
  "New session")
    name=$(echo "" | fzf-tmux -p -w 40% -h 20% \
      --header="Session name:" \
      --print-query \
      --no-info \
      --reverse | head -1)
    [[ -z "$name" ]] && exit 0
    tmux new-session -d -s "$name"
    tmux switch-client -t "$name"
    ;;
  "Pane: main left")
    tmux select-layout main-vertical
    ;;
  "Pane: main right")
    tmux select-layout main-vertical
    tmux rotate-window
    ;;
  "Quick Claude")
    dir=$(tmux display-message -p '#{pane_current_path}')
    node_version=$(mise current -C ~ node)
    tmux display-popup -w 80% -h 80% -d "$dir" -E "mise x node@$node_version -- claude --dangerously-skip-permissions --model haiku"
    ;;
  "Remove Worktree")
    dir=$(tmux display-message -p '#{pane_current_path}')
    worktrees=$(git -C "$dir" worktree list --porcelain 2>/dev/null | \
      grep "^branch refs/heads/" | sed 's|^branch refs/heads/||')
    if [[ -z "$worktrees" ]]; then
      tmux display-message "No worktrees found"
      exit 0
    fi
    current_branch=$(git -C "$dir" symbolic-ref --short HEAD 2>/dev/null)
    fzf_query=""
    if [[ -n "$current_branch" && "$current_branch" != "master" && "$current_branch" != "main" && "$current_branch" != "develop" ]]; then
      fzf_query="--query=$current_branch"
    fi
    selected=$(echo "$worktrees" | fzf-tmux -p -w 40% -h 30% \
      --header="Select worktrees to remove:" \
      --multi \
      --reverse \
      $fzf_query)
    [[ -z "$selected" ]] && exit 0
    # Join selected branches with spaces
    branches=$(echo "$selected" | tr '\n' ' ' | sed 's/ $//')
    tmux send-keys "wt remove $branches" Enter
    ;;
  "Merge Worktree")
    dir=$(tmux display-message -p '#{pane_current_path}')
    worktrees=$(git -C "$dir" worktree list --porcelain 2>/dev/null | \
      grep "^branch refs/heads/" | sed 's|^branch refs/heads/||')
    if [[ -z "$worktrees" ]]; then
      tmux display-message "No worktrees found"
      exit 0
    fi
    selected=$(echo "$worktrees" | fzf-tmux -p -w 40% -h 30% \
      --header="Select worktree to merge:" \
      --reverse \
      --query=master)
    [[ -z "$selected" ]] && exit 0
    tmux send-keys "wt merge --no-squash $selected" Enter
    ;;
  "Rename session")
    current=$(tmux display-message -p '#S')
    name=$(echo "" | fzf-tmux -p -w 40% -h 20% \
      --header="Rename '$current' to:" \
      --print-query \
      --no-info \
      --reverse | head -1)
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
  "Send keybinding to all panes")
    selection=$(printf "Ctrl+c\nEnter\nEscape" | fzf-tmux -p -w 40% -h 20% \
      --header="Keybinding to send:" \
      --no-multi \
      --reverse)
    [[ -z "$selection" ]] && exit 0
    case "$selection" in
      "Ctrl+c") key="C-c" ;;
      *) key="$selection" ;;
    esac
    tmux list-panes -F '#{pane_id}' | while read -r pane; do
      tmux send-keys -t "$pane" "$key"
    done
    ;;
  "Send to all panes")
    text=$(echo "" | fzf-tmux -p -w 60% -h 20% \
      --header="Text to send to all panes:" \
      --print-query \
      --no-info \
      --reverse | head -1)
    [[ -z "$text" ]] && exit 0
    tmux list-panes -F '#{pane_id}' | while read -r pane; do
      tmux send-keys -t "$pane" "$text"
    done
    ;;
  "Kick SSH clients")
    tmux detach-client -a
    tmux display-message "Detached all other clients"
    ;;
esac
