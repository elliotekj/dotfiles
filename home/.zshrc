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
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"

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

worktree() {
  if [ -z "$1" ]; then
    echo "Usage: worktree <branch-name>"
    return 1
  fi

  BRANCH="$1"
  DIR_NAME=$(basename "$PWD")
  PATH_TO_WORKTREE="../${DIR_NAME}_worktrees/${BRANCH}"
  WINDOW_NAME="${DIR_NAME} ${BRANCH}"

  mkdir -p "../${DIR_NAME}_worktrees/feat"
  mkdir -p "../${DIR_NAME}_worktrees/fix"

  echo "🔄 Fetching latest from origin..."
  git fetch origin master

  if git show-ref --verify --quiet refs/heads/"$BRANCH"; then
    echo "🎯 Existing branch '$BRANCH', adding worktree at '$PATH_TO_WORKTREE'..."
    git worktree add "$PATH_TO_WORKTREE" "$BRANCH"
  else
    echo "✨ New branch '$BRANCH', creating worktree at '$PATH_TO_WORKTREE'..."
    git worktree add -b "$BRANCH" "$PATH_TO_WORKTREE" origin/master
  fi

  echo "🚀 Worktree ready at '$PATH_TO_WORKTREE'!"

  # Create a new tmux window
  tmux new-window -n "$WINDOW_NAME" "cd '$PATH_TO_WORKTREE' && \
    if [ -f mix.exs ]; then \
      echo '📦 Found mix.exs, setting up dependencies...' && \
      mix deps.get && \
      mix setup; \
    fi; \
    exec zsh"
}

yank() {
  if [ -f "$1" ]; then
    pbcopy < "$1"
    echo "Yanked contents of '$1' to clipboard."
  else
    echo "Error: '$1' is not a valid file."
  fi
}

if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

