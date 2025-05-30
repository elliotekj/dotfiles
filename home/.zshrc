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
export PATH="$HOME/.local/share/mise/installs/node/$(mise current -C ~ node)/bin:$PATH"

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
autoload -Uz compinit && compinit

eval "$(zoxide init zsh)"

# persist iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"

alias v="nvim"
alias phx="iex -S mix phx.server"
alias master="git checkout master && git pull && mix deps.get"

branch() {
  if [ -z "$1" ]; then
    echo "Usage: branch <branch-name>"
    return 1
  fi

  if git show-ref --verify --quiet refs/heads/"$1"; then
    echo "🎯 Existing branch '$1'..."
    git checkout "$1"
    git pull origin "$1"
  else
    echo "✨ New branch '$1'..."
    git checkout -b "$1"
  fi

  if [ -f "mix.exs" ]; then
    mix deps.get
  fi
}

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

