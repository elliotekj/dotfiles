fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

autoload -Uz compinit && compinit

source <(carapace _carapace zsh)

compdef _files yank
