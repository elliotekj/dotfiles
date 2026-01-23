#!/usr/bin/env bash
#
# worktree_container_cleanup.sh
#
# Monitors git worktrees in ~/dev/knox and ~/dev/cctv, running container
# cleanup commands (just dd && just td) in worktrees without active tmux panes.

set -euo pipefail

BASE_DIRS=(
    "$HOME/dev/knox"
    "$HOME/dev/cctv"
)

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*"
}

has_active_pane() {
    local worktree_path="$1"
    tmux list-panes -a -F '#{pane_current_path}' 2>/dev/null | grep -q "^${worktree_path}"
}

get_worktrees() {
    local base_dir="$1"
    if [[ -d "$base_dir" ]]; then
        git -C "$base_dir" worktree list --porcelain 2>/dev/null | grep '^worktree ' | cut -d' ' -f2-
    fi
}

cleanup_worktree() {
    local worktree="$1"
    log "Cleaning up containers in: $worktree"
    if (cd "$worktree" && just dd && just td); then
        log "Cleanup completed for: $worktree"
    else
        log "Cleanup failed for: $worktree" >&2
    fi
}

main() {
    log "Starting worktree container cleanup"

    for base_dir in "${BASE_DIRS[@]}"; do
        if [[ ! -d "$base_dir" ]]; then
            log "Skipping non-existent directory: $base_dir"
            continue
        fi

        log "Processing base directory: $base_dir"

        while IFS= read -r worktree; do
            [[ -z "$worktree" ]] && continue

            if has_active_pane "$worktree"; then
                log "Skipping (active tmux pane): $worktree"
            else
                cleanup_worktree "$worktree"
            fi
        done < <(get_worktrees "$base_dir")
    done

    log "Worktree container cleanup completed"
}

main
