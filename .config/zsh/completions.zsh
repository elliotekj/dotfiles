fpath=($HOME/.homesick/repos/homeshick/completions $fpath)

autoload -Uz compinit

zcompdump_path="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ ! -f "$zcompdump_path" ]]; then
    compinit -d "$zcompdump_path"
else
    compinit -C -d "$zcompdump_path"
fi

_source_generated_init carapace-init.zsh carapace _carapace zsh

compdef _files yank
