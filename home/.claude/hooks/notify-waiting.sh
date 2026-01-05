#!/usr/bin/env bash
[[ -z "$TMUX" ]] && exit 0

# Read JSON input from Claude Code
input=$(cat)
transcript_path=$(echo "$input" | jq -r '.transcript_path // empty')

# Expand tilde to home directory (if present)
transcript_path="${transcript_path/#\~/$HOME}"

# Extract slug from transcript file
slug=""
if [[ -n "$transcript_path" && -f "$transcript_path" ]]; then
  slug=$(grep -o '"slug":"[^"]*"' "$transcript_path" | head -1 | cut -d'"' -f4)
fi

tmux set-option -w -t "$TMUX_PANE" @claude_waiting 1
[[ -n "$slug" ]] && tmux set-option -w -t "$TMUX_PANE" @claude_session_name "$slug"

echo '{"decision": "approve"}'
