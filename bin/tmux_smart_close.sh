#!/usr/bin/env bash
# Smart pane closing for tmux
# If Helix is running, send Ctrl+W to it (for window navigation)
# Otherwise, kill the pane

# Get the current pane's running command
pane_cmd=$(tmux display-message -p '#{pane_current_command}')

# Check if Helix (hx) is running
if [[ "$pane_cmd" == hx* ]]; then
  # Helix is running - send Ctrl+W to it for window navigation
  tmux send-keys C-w
else
  # Helix is not running - kill the pane
  tmux kill-pane
fi
