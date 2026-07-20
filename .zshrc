source "${ZDOTDIR:-$HOME}/.config/zsh/env.zsh"
[ -s ~/.env.local ] && source ~/.env.local

_source_generated_init() {
    local cache_name="$1"
    shift

    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
    local cache_path="${cache_dir}/${cache_name}"
    local cmd_path tmp_path

    cmd_path=$(command -v "$1" 2>/dev/null) || return 0

    if ! mkdir -p "$cache_dir" 2>/dev/null; then
        eval "$("$@")"
        return
    fi

    if [[ ! -s "$cache_path" || "$cmd_path" -nt "$cache_path" ]]; then
        tmp_path="${cache_path}.tmp.$$"
        if "$@" >| "$tmp_path" 2>/dev/null; then
            mv "$tmp_path" "$cache_path"
        else
            rm -f "$tmp_path"
        fi
    fi

    [[ -s "$cache_path" ]] && source "$cache_path"
}

source "${ZDOTDIR:-$HOME}/.config/zsh/aliases.zsh"
source "${ZDOTDIR:-$HOME}/.config/zsh/prompt.zsh"

for func_file in "${ZDOTDIR:-$HOME}"/.config/zsh/functions/*.zsh; do
    source "$func_file"
done

source "${ZDOTDIR:-$HOME}/.config/zsh/completions.zsh"

_source_generated_init zoxide-init.zsh zoxide init zsh
_source_generated_init atuin-init.zsh atuin init zsh
_source_generated_init direnv-init.zsh direnv hook zsh

[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

ulimit -n 512

[ -s ~/.zshrc.local ] && source ~/.zshrc.local

_source_generated_init wt-init.zsh wt config shell init zsh

if command -v ng >/dev/null 2>&1; then
    ng_completion_cache="${XDG_CACHE_HOME:-$HOME/.cache}/ng-completion.zsh"
    mkdir -p "${ng_completion_cache:h}"

    if [[ ! -s "$ng_completion_cache" || "$(command -v ng)" -nt "$ng_completion_cache" ]]; then
        command ng completion script >| "$ng_completion_cache" 2>/dev/null
    fi

    [ -s "$ng_completion_cache" ] && source "$ng_completion_cache"
fi

# Pi
export PATH="/Users/elliot.jackson/.local/share/mise/installs/node/25.9.0/bin:$PATH"
