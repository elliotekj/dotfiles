master() {
    git checkout master
    git pull
    if [ -f "mix.exs" ]; then
        mix deps.get
    fi
}

branch() {
    if [ -z "$1" ]; then
        echo "Usage: branch <branch-name>"
        return 1
    fi

    local branch_name="$1"

    if git show-ref --verify --quiet "refs/heads/$branch_name"; then
        echo "Existing branch '$branch_name'..."
        git checkout "$branch_name"
        git pull origin "$branch_name"
    else
        echo "New branch '$branch_name'..."
        git checkout -b "$branch_name"
    fi

    if [ -f "mix.exs" ]; then
        mix deps.get
    fi

    if [ -n "$TMUX" ]; then
        local basedir
        basedir=$(basename "$PWD")
        tmux rename-window "${basedir}:${branch_name}"
    fi
}

alias r=tuicr

fix() {
    if [ -z "$1" ]; then
        echo "Usage: fix <branch-name>"
        return 1
    fi
    branch "fix/$1"
}

feat() {
    if [ -z "$1" ]; then
        echo "Usage: feat <branch-name>"
        return 1
    fi
    branch "feat/$1"
}

_get_parent_project() {
    local origin
    origin=$(git config --get remote.origin.url)
    echo "$origin" | sed -E 's/.*[\/:]//; s/\.[^.]*$//'
}

review() {
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        echo "Error: Not in a git repository"
        return 1
    fi

    local base_branch="${1:-}"

    if [ -z "$base_branch" ]; then
        if git show-ref --verify --quiet refs/heads/main; then
            base_branch="main"
        elif git show-ref --verify --quiet refs/heads/master; then
            base_branch="master"
        else
            echo "Error: Could not find main or master branch"
            echo "Usage: review [base-branch]"
            return 1
        fi
    fi

    local current_branch
    current_branch=$(git branch --show-current)

    if [ "$current_branch" = "$base_branch" ]; then
        echo "Error: Already on $base_branch. Switch to a feature branch to review."
        return 1
    fi

    local merge_base
    merge_base=$(git merge-base "$base_branch" HEAD)

    if [ -z "$merge_base" ]; then
        echo "Error: Could not determine merge base with $base_branch"
        return 1
    fi

    local changed_files
    changed_files=$(git diff --name-only "$merge_base"...HEAD)

    if [ -z "$changed_files" ]; then
        echo "No changes between $base_branch and $current_branch"
        return 0
    fi

    local file_count
    file_count=$(echo "$changed_files" | wc -l | tr -d ' ')

    local stats
    stats=$(git diff --shortstat "$merge_base"...HEAD | sed 's/^ *//')

    echo "$file_count files | $stats"
    echo "$current_branch -> $base_branch"
    echo

    GIT_EXTERNAL_DIFF='difft --color always --display side-by-side' git diff --ext-diff "$merge_base"...HEAD
}
