#!/usr/bin/env bash
# Toggle @flash_phase between 0 and 1 every second
# Used for Claude Code waiting notification in tmux tabs

while true; do
    current=$(tmux show-option -gqv @flash_phase)
    if [[ "$current" == "1" ]]; then
        tmux set-option -g @flash_phase 0
    else
        tmux set-option -g @flash_phase 1
    fi
    sleep 1
done
