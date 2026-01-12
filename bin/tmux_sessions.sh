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
            output+="#[bg=#ffc799,fg=#101010,bold] $session #[bg=#101010,fg=#ffffff,nobold]"
        else
            output+="#[bg=#99ffe4,fg=#101010,bold] $session #[bg=#101010,fg=#ffffff,nobold]"
        fi
    else
        if [[ "$should_flash" == "1" ]]; then
            output+="#[bg=#ffc799,fg=#101010] $session #[bg=#101010,fg=#ffffff]"
        else
            output+="#[bg=#343434,fg=#ffffff] $session #[bg=#101010]"
        fi
    fi
done

echo "$output"
