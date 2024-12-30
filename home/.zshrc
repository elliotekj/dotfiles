eval "$(/opt/homebrew/bin/brew shellenv)"

. "$HOME/.asdf/asdf.sh"
. ~/.asdf/plugins/golang/set-env.zsh
. /opt/homebrew/etc/profile.d/z.sh

# append completions to fpath
fpath=(${ASDF_DIR}/completions $fpath)
fpath=($HOME/.homesick/repos/homeshick/completions $fpath)
# initialise completions with ZSH's compinit
autoload -Uz compinit && compinit

. "$HOME/.cargo/env"

# use gpg-agent for SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# persist iex shell history
export ERL_AFLAGS="-kernel shell_history enabled"

# opt in to rust llambdas
SAM_CLI_BETA_RUST_CARGO_LAMBDA=1

# add dotnet tools to path
export PATH="$PATH:/Users/elliot/.dotnet/tools"

# add flutter to path
export PATH="$PATH:/Users/elliot/dev/flutter/bin"

alias phx="iex -S mix phx.server"

eval "$(atuin init zsh)"
eval "$(starship init zsh)"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


