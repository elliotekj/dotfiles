alias c='mise x node@$(mise current -C ~ node) -- claude --dangerously-skip-permissions'
alias codex='mise x node@$(mise current -C ~ node) -- codex'
alias amp='mise x node@$(mise current -C ~ node) -- amp'
alias droid='mise x node@$(mise current -C ~ node) -- droid'
alias g="gitu"
alias gap="git add -p"
alias gcp="git cherry-pick"
alias gs='git stack --no-revise-sign --branch-prefix="elliot/" --draft'
alias j="just"
alias lg="lazygit"
alias phx="iex -S mix phx.server"
alias wtc="wt switch --create"
alias wts="wt select"
alias v="nvim"
alias y="yazi"

tsn() {
  if [[ -n "$TMUX" ]]; then
    tmux new -s "$1" -d && tmux switch-client -t "$1"
  else
    tmux new -s "$1"
  fi
}

if command -v eza &> /dev/null; then
  alias ls="eza -l --git --time-style=relative"
fi

d() {
  local dir
  dir=$(fd --type d --max-depth 1 . ~/dev | fzf --reverse) && cd "$dir"
}
