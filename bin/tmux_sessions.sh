#!/bin/bash
# List all tmux sessions with active session highlighted
# Sessions with AI-waiting windows flash orange

current_session=$(tmux display-message -p '#S')
sessions=$(tmux list-sessions -F '#S' 2>/dev/null)
flash_phase=$(tmux show-option -gqv @flash_phase)

session_has_waiting() {
    local session="$1"
    tmux list-windows -t "$session" -F '#{@claude_waiting}' 2>/dev/null | grep -q '^1$'
}

output=""
for session in $sessions; do
    # Skip archived sessions
    archived=$(tmux show-option -t "$session" -qv @archived)
    [[ "$archived" == "1" ]] && continue

    has_waiting=$(session_has_waiting "$session" && echo 1 || echo 0)
    should_flash=$([[ "$has_waiting" == "1" && "$flash_phase" == "1" ]] && echo 1 || echo 0)

    if [[ "$session" == "$current_session" ]]; then
        if [[ "$should_flash" == "1" ]]; then
            output+="#[bg=#f6c177,fg=#191724,bold] $session #[bg=#191724,fg=#e0def4,nobold]"
        else
            output+="#[bg=#ebbcba,fg=#191724,bold] $session #[bg=#191724,fg=#e0def4,nobold]"
        fi
    else
        if [[ "$should_flash" == "1" ]]; then
            output+="#[bg=#f6c177,fg=#191724] $session #[bg=#191724,fg=#e0def4]"
        else
            output+="#[bg=#191724,fg=#908caa] $session #[bg=#191724]"
        fi
    fi
done

echo "$output"
