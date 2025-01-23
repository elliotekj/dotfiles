if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
eval "$(~/.local/bin/mise activate zsh)"
eval "$(direnv hook zsh)"
eval "$(atuin init zsh)"
eval "$(starship init zsh)"

export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"

eval ". $(brew --prefix)/etc/profile.d/z.sh"

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
autoload -Uz compinit && compinit

# persist iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"

alias v="nvim"
alias phx="iex -S mix phx.server"

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

