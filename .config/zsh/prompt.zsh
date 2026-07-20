_git_branch() {
    local branch
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo " %F{bright-black}${branch}%f"
    fi
}

_prompt_path() {
    echo "${PWD/#$HOME/~}"
}

setopt PROMPT_SUBST

PROMPT='%B%F{magenta}$(_prompt_path)%f%b$(_git_branch) %F{magenta}❯%f '
RPROMPT=''
