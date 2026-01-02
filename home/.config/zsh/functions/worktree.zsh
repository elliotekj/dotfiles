_setup_worktree() {
    local worktree_path="$1"
    local parent="$2"

    cd "$worktree_path" || return 1

    if [ -f "mix.exs" ]; then
        local parent_path
        parent_path=$(cd "../$parent" && pwd)

        if [ -d "$parent_path/deps" ]; then
            cp -r "$parent_path/deps" .
        fi

        if [ -d "$parent_path/_build" ]; then
            cp -r "$parent_path/_build" .
        fi
    fi

    if [ -f "assets/package-lock.json" ]; then
        npm i --prefix assets
    fi

    if [ -f "assets/yarn.lock" ]; then
        (cd assets && yarn install)
    fi

    local env_file
    env_file=$(cd "../$parent" && pwd)/.env
    if [ -f "$env_file" ]; then
        cp "$env_file" .
    fi
}

_setup_mcp_servers() {
    local worktree_path="$1"

    local mcp_options="RepoPrompt
chrome-devtools
linear-server"

    local selected
    selected=$(echo "$mcp_options" | fzf --multi --prompt "Select MCP servers (TAB to multi-select, ENTER to confirm): " --height 40%)

    if [ -z "$selected" ]; then
        return
    fi

    echo "$selected" | while IFS= read -r server; do
        case "$server" in
            "RepoPrompt")
                claude mcp add RepoPrompt /Users/elliotekj/RepoPrompt/repoprompt_cli
                ;;
            "chrome-devtools")
                claude mcp add chrome-devtools npx chrome-devtools-mcp@latest
                ;;
            "linear-server")
                claude mcp add --transport http linear-server https://mcp.linear.app/mcp
                ;;
        esac
    done

    echo "MCP servers configured: $(echo "$selected" | tr '\n' ', ' | sed 's/, $//')"
}

mkwt() {
    if [ -z "$1" ]; then
        echo "Usage: mkwt <branch-name>"
        return 1
    fi

    local name="$1"
    local parent
    parent=$(_get_parent_project)

    local dir_name="${name//\//-}"
    local worktree_path
    worktree_path=$(cd .. && pwd)/worktree-${parent}-${dir_name}

    git worktree add -b "$name" "$worktree_path"
    _setup_worktree "$worktree_path" "$parent"
    _setup_mcp_servers "$worktree_path"

    echo "Worktree created at $worktree_path with branch $name"
}

cowt() {
    if [ -z "$1" ]; then
        echo "Usage: cowt <branch-name>"
        return 1
    fi

    local branch_name="$1"
    local parent
    parent=$(_get_parent_project)

    local dir_name="${branch_name//\//-}"
    local worktree_path
    worktree_path=$(cd .. && pwd)/worktree-${parent}-${dir_name}

    git worktree add "$worktree_path" "$branch_name"

    cd "$worktree_path" || return 1
    git pull

    _setup_worktree "$worktree_path" "$parent"
    _setup_mcp_servers "$worktree_path"

    echo "Worktree created at $worktree_path checking out branch $branch_name"
}

rmwt() {
    local current_dir="$PWD"
    local branch_name
    branch_name=$(git branch --show-current)

    local git_path="$current_dir/.git"

    if [ ! -e "$git_path" ]; then
        echo "Error: Not in a git repository."
        return 1
    fi

    if [ -d "$git_path" ]; then
        echo "Error: Not in a worktree directory. This command must be run from within a worktree."
        return 1
    fi

    echo "This will delete:"
    echo "  - Worktree: $current_dir"
    echo "  - Branch: $branch_name"
    echo ""

    echo -n "Are you sure you want to proceed? (yes/no): "
    read confirm

    if [ "$(echo "$confirm" | tr '[:upper:]' '[:lower:]')" != "yes" ]; then
        echo "Deletion cancelled."
        return 0
    fi

    local parent
    parent=$(_get_parent_project)

    cd "../$parent" || return 1

    if ! git worktree remove "$current_dir" 2>/dev/null; then
        echo "Initial removal failed. Attempting force removal..."
        if ! git worktree remove --force "$current_dir" 2>/dev/null; then
            echo "Force removal failed. Cleaning up manually..."
            rm -rf "$current_dir"
            git worktree prune
        fi
    fi

    git branch -D "$branch_name"

    echo "Deleted worktree at $current_dir and branch $branch_name"
}
