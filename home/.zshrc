eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(~/.local/bin/mise activate zsh)"
eval "$(direnv hook zsh)"

export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"

. /opt/homebrew/etc/profile.d/z.sh

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
autoload -Uz compinit && compinit

# persist iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"

alias phx="iex -S mix phx.server"

eval "$(atuin init zsh)"
eval "$(starship init zsh)"

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

