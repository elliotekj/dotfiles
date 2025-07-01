#!/usr/bin/env bash

# Suppress terminal error output
exec 2>/dev/null

# Cleanup any old chooser file
rm -f /tmp/yazi-dir-pick

# Run yazi and wait for selection
if [ "$USER" = "elliot" ]; then
  DEV_DIR="/Volumes/External/dev"
else
  DEV_DIR="$HOME/dev"
fi

yazi "$DEV_DIR" --chooser-file /tmp/yazi-dir-pick

# Exit if nothing was selected
[[ ! -f /tmp/yazi-dir-pick ]] && exit 0

# Get the selection path
DIR=$(cat /tmp/yazi-dir-pick)
rm /tmp/yazi-dir-pick

# If a file was selected, use its directory
[[ -f "$DIR" ]] && DIR=$(dirname "$DIR")

# Normalize the path
DIR=$(realpath "$DIR")

# Get base directory name
WIN_NAME=$(basename "$DIR")

# Check if it's a Git repo and get branch name
if git -C "$DIR" rev-parse --is-inside-work-tree &>/dev/null; then
    BRANCH=$(git -C "$DIR" rev-parse --abbrev-ref HEAD 2>/dev/null)
    [[ -n "$BRANCH" ]] && WIN_NAME="${WIN_NAME}:${BRANCH}"
fi

# Create the tmux window in that directory with a custom name
tmux new-window -c "$DIR" -n "$WIN_NAME"
