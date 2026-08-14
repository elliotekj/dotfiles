c() {
  codex --dangerously-bypass-approvals-and-sandbox "$@"
}

o() {
  opencode "$@"
}
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
alias vim='$EDITOR'
alias y="yazi"
alias spec='$EDITOR SPEC.md'
alias t="tuicr --appearance system"

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
