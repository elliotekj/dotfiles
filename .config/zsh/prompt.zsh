_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " %F{#8be9fd}${branch}%f"
    fi
}

_prompt_path() {
    echo "${PWD/#$HOME/~}"
}

setopt PROMPT_SUBST

PROMPT='%F{#bd93f9}$(_prompt_path)%f$(_git_branch) %F{#ff79c6}❯%f '
RPROMPT=''
