#!/usr/bin/env bash
# Commands palette for tmux session management

# Import DEV_BASE from tmux environment (run-shell doesn't inherit shell env).
# tmux show-environment outputs "VAR=value" when set, "-VAR" when removed.
# The cut approach silently misparses the removed form, so match explicitly.
if [[ -z "$DEV_BASE" ]]; then
  _val=$(tmux show-environment DEV_BASE 2>/dev/null)
  [[ "$_val" == DEV_BASE=* ]] && DEV_BASE="${_val#DEV_BASE=}"
fi
if [[ -z "$DEV_BASE" ]]; then
  _val=$(tmux show-environment -g DEV_BASE 2>/dev/null)
  [[ "$_val" == DEV_BASE=* ]] && DEV_BASE="${_val#DEV_BASE=}"
fi
# Fallback: mirror env.zsh logic when tmux env is missing or stale.
if [[ -z "$DEV_BASE" || ! -d "$DEV_BASE" ]]; then
  if [[ -d "/Volumes/External/dev" ]]; then
    DEV_BASE="/Volumes/External/dev/"
  else
    DEV_BASE="$HOME/dev/"
  fi
fi

# Run a gum command in a tmux popup (no stdin piping).
# Usage: popup_gum <width> <height> <command>
# Result in $REPLY, empty on cancel.
popup_gum() {
  local tmpfile
  tmpfile=$(mktemp /tmp/tmux-popup-XXXXXX)
  tmux display-popup -w "$1" -h "$2" -E "$3 > '$tmpfile'"
  REPLY=$(cat "$tmpfile" 2>/dev/null)
  rm -f "$tmpfile"
}

# Run a gum command in a tmux popup, piping data from stdin.
# Usage: popup_gum_pipe <width> <height> <command> < <(echo "$items")
# Result in $REPLY, empty on cancel.
popup_gum_pipe() {
  local infile outfile
  infile=$(mktemp /tmp/tmux-in-XXXXXX)
  outfile=$(mktemp /tmp/tmux-out-XXXXXX)
  cat > "$infile"
  tmux display-popup -w "$1" -h "$2" -E "cat '$infile' | $3 > '$outfile'"
  REPLY=$(cat "$outfile" 2>/dev/null)
  rm -f "$infile" "$outfile"
}

# Base commands
commands="Archive session\nCheckout Worktree\nCopy PID\nDebug & Fix\nExtract\nFiles\nGit\nGitHub\nHtop\nImplement Feature\nKill session\nLayout: horizontal\nLayout: vertical\nMail\nMerge Worktree\nNew session\nPane: main left\nPane: main right\nQuick Claude\nRemove Worktree\nRename session\nRestore session\nReview PR\nSend keybinding to all panes\nSend to all panes"

# Add option to kick SSH clients when local and other clients are attached
if [[ -z "$SSH_CONNECTION" ]] && [ "$(tmux list-clients | wc -l | tr -d ' ')" -gt 1 ]; then
  commands="$commands\nKick SSH clients"
fi

popup_gum_pipe '40%' '30%' "gum filter --strict --no-show-help --placeholder 'Commands...' --height 20" < <(echo -e "$commands")
selected="$REPLY"

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
    popup_gum_pipe '40%' '30%' "gum filter --no-show-help --placeholder 'Branch name or new...' --height 20" \
      < <(git -C "$dir" branch --format='%(refname:short)' 2>/dev/null)
    name="$REPLY"
    [[ -z "$name" ]] && exit 0

    # Window name: strip --base flag and trim
    window_name="${name%% --base*}"
    window_name="${window_name%% }"

    # Compute worktree directory path
    repo_name=$(basename "$dir")
    sanitized=$(echo "$name" | tr '/' '-')
    wt_dir="$(cd "$dir/.." && pwd)/${repo_name}.worktrees/${sanitized}"

    # Create new window with branch name, starting in same directory
    tmux new-window -n "$window_name" -c "$dir"

    # Switch/create worktree in this pane (will become top-left)
    if git -C "$dir" worktree list --porcelain | grep -q "^branch refs/heads/$name$"; then
      tmux send-keys "wt switch '$name'" Enter
    else
      tmux send-keys "wt switch --yes --create '$name'" Enter
    fi

    # Split vertically (creates right pane)
    tmux split-window -h -c "$wt_dir"

    # Go back to left pane and split horizontally (creates bottom-left pane)
    tmux select-pane -L
    tmux split-window -v -c "$wt_dir"

    # Run `g` in top-left pane
    tmux select-pane -U
    tmux send-keys "g" Enter

    # Run `c` in right pane and leave cursor there
    tmux select-pane -R
    tmux send-keys "c" Enter
    ;;
  "Copy PID")
    pane_pid=$(tmux display-message -p '#{pane_pid}')
    child_pid=$(pgrep -P "$pane_pid" 2>/dev/null | head -1)
    pid=${child_pid:-$pane_pid}
    echo -n "$pid" | pbcopy
    tmux display-message "Copied PID: $pid"
    ;;
  "Debug & Fix")
    popup_gum '50%' '40%' "gum write --char-limit 0 --placeholder 'Describe the issue...'"
    prompt="$REPLY"
    [[ -z "$prompt" ]] && exit 0

    # Select project from DEV_BASE
    projects=$(ls -1d "${DEV_BASE}"*/ 2>/dev/null | xargs -n1 basename)
    popup_gum_pipe '40%' '40%' "gum filter --strict --no-show-help --placeholder 'Select project...' --height 20" <<< "$projects"
    project="$REPLY"
    [[ -z "$project" ]] && exit 0
    dir="${DEV_BASE}${project}"

    # Worktree option
    popup_gum '40%' '15%' "if gum confirm 'Create worktree?' --no-show-help --default=true; then echo yes; else echo no; fi"
    use_worktree="$REPLY"

    title=$(env MAX_THINKING_TOKENS=0 claude -p \
      --model=haiku --tools='' --disable-slash-commands \
      --setting-sources='' --system-prompt='' \
      "Output ONLY a short plaintext title (max 4 words) for the following prompt. No markdown, no headings, no formatting, no quotes, just the raw words: $prompt" 2>/dev/null)
    title=$(echo "$title" | sed 's/^[#*>`_ -]*//' | tr -d '\n' | head -c 30)
    [[ -z "$title" ]] && title="Debug & Fix"

    safe_prompt="${prompt//\'/\'\\\'\'}"
    if tmux has-session -t "=$project" 2>/dev/null; then
      tmux switch-client -t "=$project"
    else
      tmux new-session -d -s "$project" -c "$dir"
      tmux switch-client -t "=$project"
    fi
    tmux new-window -n "$title" -c "$dir"
    if [[ "$use_worktree" == "yes" ]]; then
      branch=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-' | sed 's/^-*//;s/-*$//')
      tmux send-keys "wt switch --yes --create '$branch' -x c -- '/debug-and-fix-team $safe_prompt'" Enter
    else
      tmux send-keys "c '/debug-and-fix-team $safe_prompt'" Enter
    fi
    ;;
  "Extract")
    tmux run-shell "~/.config/tmux/plugins/extrakto/scripts/open.sh '#{pane_id}'"
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
  "Implement Feature")
    popup_gum '50%' '40%' "gum write --char-limit 0 --placeholder 'Describe the feature...'"
    prompt="$REPLY"
    [[ -z "$prompt" ]] && exit 0

    # Select project from DEV_BASE
    projects=$(ls -1d "${DEV_BASE}"*/ 2>/dev/null | xargs -n1 basename)
    popup_gum_pipe '40%' '40%' "gum filter --strict --no-show-help --placeholder 'Select project...' --height 20" <<< "$projects"
    project="$REPLY"
    [[ -z "$project" ]] && exit 0
    dir="${DEV_BASE}${project}"

    # Worktree option
    popup_gum '40%' '15%' "if gum confirm 'Create worktree?' --no-show-help --default=true; then echo yes; else echo no; fi"
    use_worktree="$REPLY"

    title=$(env MAX_THINKING_TOKENS=0 claude -p \
      --model=haiku --tools='' --disable-slash-commands \
      --setting-sources='' --system-prompt='' \
      "Output ONLY a short plaintext title (max 4 words) for the following prompt. No markdown, no headings, no formatting, no quotes, just the raw words: $prompt" 2>/dev/null)
    title=$(echo "$title" | sed 's/^[#*>`_ -]*//' | tr -d '\n' | head -c 30)
    [[ -z "$title" ]] && title="Feature"

    safe_prompt="${prompt//\'/\'\\\'\'}"
    if tmux has-session -t "=$project" 2>/dev/null; then
      tmux switch-client -t "=$project"
    else
      tmux new-session -d -s "$project" -c "$dir"
      tmux switch-client -t "=$project"
    fi
    tmux new-window -n "$title" -c "$dir"
    if [[ "$use_worktree" == "yes" ]]; then
      branch=$(echo "$title" | tr '[:upper:]' '[:lower:]' | tr ' ' '-' | tr -cd 'a-z0-9-' | sed 's/^-*//;s/-*$//')
      tmux send-keys "wt switch --yes --create '$branch' -x c -- '/feature-impl-team $safe_prompt'" Enter
    else
      tmux send-keys "c '/feature-impl-team $safe_prompt'" Enter
    fi
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
    popup_gum '40%' '20%' "gum input --char-limit 0 --placeholder 'Session name...'"
    name="$REPLY"
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
    gum_value=""
    if [[ -n "$current_branch" && "$current_branch" != "master" && "$current_branch" != "main" && "$current_branch" != "develop" ]]; then
      gum_value="--value '$current_branch'"
    fi
    popup_gum_pipe '40%' '30%' "gum filter --no-limit --no-show-help --placeholder 'Select worktrees to remove...' --height 20 $gum_value" < <(echo "$worktrees")
    selected="$REPLY"
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
    popup_gum_pipe '40%' '30%' "gum filter --strict --no-show-help --value 'master' --placeholder 'Select worktree to merge...' --height 20" < <(echo "$worktrees")
    selected="$REPLY"
    [[ -z "$selected" ]] && exit 0
    tmux send-keys "wt merge $selected" Enter
    tmux rename-window "$selected"
    ;;
  "Rename session")
    current=$(tmux display-message -p '#S')
    popup_gum '40%' '20%' "gum input --char-limit 0 --placeholder 'Rename $current to...'"
    name="$REPLY"
    [[ -z "$name" ]] && exit 0
    tmux rename-session "$name"
    ;;
  "Review PR")
    popup_gum '60%' '20%' "gum input --char-limit 0 --placeholder 'PR URL...'"
    url="$REPLY"
    [[ -z "$url" ]] && exit 0
    title=$(gh pr view "$url" --json title -q .title 2>/dev/null)
    if [[ -z "$title" ]]; then
      tmux display-message "Failed to fetch PR title"
      exit 0
    fi
    # Create code_review session if it doesn't exist
    if ! tmux has-session -t "code_review" 2>/dev/null; then
      tmux new-session -d -s "code_review" -n "$title"
    else
      tmux new-window -t "code_review" -n "$title"
    fi
    tmux send-keys -t "code_review" "c \"/review-teller-pr $url\"" Enter
    tmux switch-client -t "code_review"
    ;;
  "Restore session")
    archived=$(tmux list-sessions -F '#S' | while read -r s; do
      [[ $(tmux show-option -t "$s" -qv @archived) == "1" ]] && echo "$s"
    done)
    if [[ -z "$archived" ]]; then
      tmux display-message "No archived sessions"
      exit 0
    fi
    popup_gum_pipe '40%' '30%' "gum filter --strict --no-show-help --placeholder 'Restore session...' --height 20" < <(echo "$archived")
    selected="$REPLY"
    [[ -z "$selected" ]] && exit 0
    tmux set-option -t "$selected" @archived 0
    tmux switch-client -t "$selected"
    ;;
  "Send keybinding to all panes")
    popup_gum '40%' '20%' "gum choose 'Ctrl+c' 'Enter' 'Escape' --header 'Keybinding to send:'"
    selection="$REPLY"
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
    popup_gum '40%' '20%' "gum input --char-limit 0 --placeholder 'Text to send to all panes...'"
    text="$REPLY"
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
