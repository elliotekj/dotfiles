#!/usr/bin/env bash

# Suppress terminal error output
exec 2>/dev/null

# Exit immediately if yazi not found
command -v yazi >/dev/null 2>&1 || { tmux new-window; exit 0; }

if [ -d "/Volumes/External/dev" ]; then
  DEV_DIR="/Volumes/External/dev"
else
  DEV_DIR="$HOME/dev"
fi

# Cleanup any old chooser file
rm -f /tmp/yazi-dir-pick

# Run yazi and wait for selection
/opt/homebrew/bin/yazi "$DEV_DIR" --chooser-file /tmp/yazi-dir-pick

# Exit if nothing was selected
[[ ! -f /tmp/yazi-dir-pick ]] && exit 0

# Get the selection path
DIR=$(cat /tmp/yazi-dir-pick)
rm -f /tmp/yazi-dir-pick

# If a file was selected, use its directory
[[ -f "$DIR" ]] && DIR=$(dirname "$DIR")

# Get base directory name
WIN_NAME=$(basename "$DIR")

# Quick git branch check
if BRANCH=$(cd "$DIR" && git symbolic-ref --short HEAD 2>/dev/null); then
    WIN_NAME="${WIN_NAME}:${BRANCH}"
fi

# Create the tmux window
tmux new-window -c "$DIR" -n "$WIN_NAME"
