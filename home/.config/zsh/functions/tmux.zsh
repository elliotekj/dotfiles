tsa() {
    local session_name="$1"

    local sessions
    sessions=$(tmux ls 2>/dev/null | cut -d: -f1)

    if [ -z "$sessions" ]; then
        echo "No tmux sessions found"
        return
    fi

    if [ -n "$session_name" ]; then
        if echo "$sessions" | grep -q "^${session_name}$"; then
            tmux attach -t "$session_name"
        else
            echo "Session '$session_name' not found"
        fi
        return
    fi

    local selected
    selected=$(echo "$sessions" | fzf --prompt "Select tmux session: " --height 40%)

    if [ -n "$selected" ]; then
        tmux attach -t "$selected"
    fi
}

