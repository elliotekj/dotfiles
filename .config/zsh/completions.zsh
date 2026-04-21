fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

autoload -Uz compinit

zcompdump_path="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f "$zcompdump_path" || -n ${zcompdump_path}(#qN.mh+24) ]]; then
    compinit -d "$zcompdump_path"
else
    compinit -C -d "$zcompdump_path"
fi

source <(carapace _carapace zsh)

compdef _files yank
