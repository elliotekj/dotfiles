_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " %F{#93a1a1}${branch}%f"
    fi
}

_prompt_path() {
    echo "${PWD/#$HOME/~}"
}

setopt PROMPT_SUBST

PROMPT='%F{#d2a8ff}$(_prompt_path)%f$(_git_branch) %F{#d2a8ff}❯%f '
RPROMPT=''
