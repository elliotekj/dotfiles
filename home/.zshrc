source ~/.config/zsh/env.zsh
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
