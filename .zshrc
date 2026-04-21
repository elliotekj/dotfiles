source ~/.config/zsh/env.zsh
[ -s ~/.env.local ] && source ~/.env.local
source ~/.config/zsh/aliases.zsh
source ~/.config/zsh/prompt.zsh

for func_file in ~/.config/zsh/functions/*.zsh; do
    source "$func_file"
done

source ~/.config/zsh/completions.zsh

eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(atuin init zsh)"

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

ulimit -n 512

[ -s ~/.zshrc.local ] && source ~/.zshrc.local

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi

export PATH=$PATH:$HOME/.maestro/bin

if command -v ng >/dev/null 2>&1; then
    ng_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/ng-completion.zsh"
    mkdir -p "${ng_completion_cache:h}"

    if [[ ! -s "$ng_completion_cache" || "$(command -v ng)" -nt "$ng_completion_cache" ]]; then
        command ng completion script >| "$ng_completion_cache" 2>/dev/null
    fi

    [ -s "$ng_completion_cache" ] && source "$ng_completion_cache"
fi
