_prompt_context() {
    local git_dir git_common_dir branch project internal_path icon

    if git_common_dir=$(command git rev-parse --path-format=absolute --git-common-dir 2>/dev/null); then
        git_dir=$(command git rev-parse --path-format=absolute --git-dir 2>/dev/null)
        branch=$(command git rev-parse --abbrev-ref HEAD 2>/dev/null)
        project="${git_common_dir:h:t}"
        internal_path=$(command git rev-parse --show-prefix 2>/dev/null)
        internal_path="${internal_path%/}"
        if [[ "$git_dir" == "$git_common_dir" ]]; then
            icon="🏠"
        else
            icon="🌳"
        fi
        if [[ -n "$internal_path" ]]; then
            print -r -- "${icon} %B%F{magenta}${project}%f%b %F{magenta}${internal_path}%f %F{bright-black}${branch}%f"
        else
            print -r -- "${icon} %B%F{magenta}${project}%f%b %F{bright-black}${branch}%f"
        fi
    else
        print -r -- "%B%F{magenta}${PWD/#$HOME/~}%f%b"
    fi
}

_codexbar_refresh_usage() {
    local cache_dir="${_CODEXBAR_PROMPT_CACHE:h}"
    local tmp_path="${_CODEXBAR_PROMPT_CACHE}.tmp.${$}.${EPOCHREALTIME//./}"

    (( $+commands[codexbar] )) || return
    command mkdir -p "$cache_dir" 2>/dev/null || return
    command codexbar usage --provider codex 2>/dev/null | command awk '
        /^Weekly:/ { gauge = $NF }
        /^Pace:/ {
            pace = $0
            sub(/^Pace: /, "", pace)
            sub(/ \|.*/, "", pace)
            sub(/ in deficit$/, " deficit", pace)
            sub(/ in reserve$/, " reserve", pace)
        }
        END {
            if (pace && gauge) print pace, gauge
        }
    ' >| "$tmp_path"

    if [[ -s "$tmp_path" ]]; then
        command mv "$tmp_path" "$_CODEXBAR_PROMPT_CACHE"
    else
        command rm -f "$tmp_path"
    fi
}

_codexbar_maybe_refresh_usage() {
    local cache_dir="${_CODEXBAR_PROMPT_CACHE:h}"
    local last_refresh=0

    (( $+commands[codexbar] )) || return
    (( EPOCHSECONDS - _CODEXBAR_REFRESH_STARTED < 60 )) && return
    if [[ -r "$_CODEXBAR_PROMPT_REFRESH" ]]; then
        IFS= read -r last_refresh < "$_CODEXBAR_PROMPT_REFRESH"
    fi
    (( EPOCHSECONDS - last_refresh < 60 )) && return

    command mkdir -p "$cache_dir" 2>/dev/null || return
    _CODEXBAR_REFRESH_STARTED=$EPOCHSECONDS
    print -r -- "$EPOCHSECONDS" >| "$_CODEXBAR_PROMPT_REFRESH"
    (_codexbar_refresh_usage) &!
}

_codexbar_prompt_usage() {
    local usage

    (( $+commands[codexbar] )) || return
    [[ -r "$_CODEXBAR_PROMPT_CACHE" ]] || return
    IFS= read -r usage < "$_CODEXBAR_PROMPT_CACHE"
    usage="${usage//\% in deficit/% deficit}"
    usage="${usage//\% in reserve/% reserve}"
    usage="${usage//\%/%%}"
    print -r -- "$usage"
}

_codexbar_schedule_refresh() {
    _codexbar_maybe_refresh_usage
    sched +00:01 _codexbar_schedule_refresh
}

zmodload zsh/datetime
zmodload zsh/sched

typeset -g _CODEXBAR_PROMPT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/codexbar-prompt"
typeset -g _CODEXBAR_PROMPT_REFRESH="${_CODEXBAR_PROMPT_CACHE}.last-refresh"
typeset -gi _CODEXBAR_REFRESH_STARTED="${_CODEXBAR_REFRESH_STARTED:-0}"
typeset -gi _CODEXBAR_REFRESH_SCHEDULED="${_CODEXBAR_REFRESH_SCHEDULED:-0}"

if (( ! _CODEXBAR_REFRESH_SCHEDULED )); then
    _CODEXBAR_REFRESH_SCHEDULED=1
    _codexbar_schedule_refresh
fi

setopt PROMPT_SUBST

PROMPT='$(_prompt_context) %F{magenta}❯%f '
RPROMPT='$(_codexbar_prompt_usage)'
