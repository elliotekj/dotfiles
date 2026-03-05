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

PROMPT='%F{#268bd2}$(_prompt_path)%f$(_git_branch) %F{#cb4b16}❯%f '
RPROMPT=''
