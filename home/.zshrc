export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"
export PATH="$HOME/.local/share/mise/installs/node/$(mise current -C ~ node)/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
autoload -Uz compinit && compinit

# persist iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"

alias v="nvim"
alias y="yazi"
alias phx="iex -S mix phx.server"
alias master="git checkout master && git pull && mix deps.get"
alias c="claude --dangerously-skip-permissions"

export EDITOR=nvim
export VISUAL=nvim

branch() {
  if [ -z "$1" ]; then
    echo "Usage: branch <branch-name>"
    return 1
  fi

  local branch_name="$1"

  if git show-ref --verify --quiet refs/heads/"$branch_name"; then
    echo "🎯 Existing branch '$branch_name'..."
    git checkout "$branch_name"
    git pull origin "$branch_name"
  else
    echo "✨ New branch '$branch_name'..."
    git checkout -b "$branch_name"
  fi

  if [ -f "mix.exs" ]; then
    mix deps.get
  fi

  # Update tmux window name if in a tmux session
  if [ -n "$TMUX" ]; then
    local basedir
    basedir=$(basename "$PWD")
    tmux rename-window "${basedir}:${branch_name}"
  fi
}

yank() {
  if [ -f "$1" ]; then
    pbcopy < "$1"
    echo "Yanked contents of '$1' to clipboard."
  else
    echo "Error: '$1' is not a valid file."
  fi
}

# Enable path tab-completion
complete -f yank 2>/dev/null || compdef _files yank

ulimit -n 512

if [ "$(uname -m)" = "arm64" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi
eval "$(~/.local/bin/mise activate zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(atuin init zsh)"

. "/Users/elliotekj/.deno/env"

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# bun completions
[ -s "/Users/elliotekj/.bun/_bun" ] && source "/Users/elliotekj/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
