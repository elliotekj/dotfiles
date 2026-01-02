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

    local file_list
    file_list=$(git diff --numstat "$merge_base"...HEAD | while read -r added deleted file; do
        [ "$added" = "-" ] && added="bin"
        [ "$deleted" = "-" ] && deleted="bin"
        printf "+%-4s -%-4s %s\n" "$added" "$deleted" "$file"
    done)

    export _REVIEW_MERGE_BASE="$merge_base"

    echo "$file_list" | fzf \
        --ansi \
        --header "$file_count files | $stats
$current_branch -> $base_branch
Enter: diff | Ctrl-O: editor | Ctrl-A: all diffs" \
        --preview "GIT_EXTERNAL_DIFF='difft --color always --display inline' git diff --ext-diff $_REVIEW_MERGE_BASE...HEAD -- {3}" \
        --preview-window "up:90%:wrap" \
        --bind "enter:execute(GIT_EXTERNAL_DIFF='difft --color always' git diff --ext-diff $_REVIEW_MERGE_BASE...HEAD -- {3} | less -R)" \
        --bind "ctrl-o:execute(${EDITOR:-hx} {3})" \
        --bind "ctrl-a:execute(GIT_EXTERNAL_DIFF='difft --color always' git diff --ext-diff $_REVIEW_MERGE_BASE...HEAD | less -R)" \
        --height "100%" \
        --border \
        --prompt "review> "

    unset _REVIEW_MERGE_BASE
}
