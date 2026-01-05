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
alias tsn="tmux new -s"
alias wtc="wt switch --create"
alias wts="wt select"
alias v="nvim"
alias y="yazi"

if command -v eza &> /dev/null; then
  alias ls="eza -l --git --time-style=relative"
fi
