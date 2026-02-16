c() {
  claude --dangerously-skip-permissions "$@"
}
alias codex='mise x node@$(mise current -C ~ node) -- codex'
alias far="serpl"
alias g="gitu"
alias gap="git add -p"
alias gcp="git cherry-pick"
alias gs='git stack --no-revise-sign --branch-prefix="elliot/" --draft'
alias i="infinite"
alias j="just"
alias m="master"
alias lg="lazygit"
alias phx="iex -S mix phx.server"
alias wtc="wt switch --create"
alias wts="wt select"
alias v='$EDITOR'
alias y="yazi"
alias spec='$EDITOR SPEC.md'

tsn() {
  if [[ -n "$TMUX" ]]; then
    tmux new -s "$1" -d && tmux switch-client -t "$1"
  else
    tmux new -s "$1"
  fi
}

d() {
  local dir
  dir=$(fd --type d --max-depth 1 . ~/dev | fzf --reverse) && cd "$dir"
}
