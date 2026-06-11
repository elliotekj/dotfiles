if [ -x "$HOME/homebrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="$HOME/homebrew"
elif [ -x "/opt/homebrew/bin/brew" ]; then
    export HOMEBREW_PREFIX="/opt/homebrew"
elif [ -x "/usr/local/bin/brew" ]; then
    export HOMEBREW_PREFIX="/usr/local"
elif command -v brew >/dev/null 2>&1; then
    export HOMEBREW_PREFIX="${$(command -v brew):h:h}"
fi

export EDITOR="nvim"
export VISUAL="nvim"

# fzf GitHub Dark theme
export FZF_DEFAULT_OPTS="
  --color=fg:#c9d1d9,bg:#0d1117,hl:#58a6ff
  --color=fg+:#e6edf3,bg+:#161b22,hl+:#58a6ff
  --color=info:#7ee787,prompt:#d2a8ff,pointer:#d2a8ff
  --color=marker:#56d364,spinner:#ffa657,header:#484f58
  --color=border:#30363d
"
export DFT_DISPLAY="side-by-side-show-both"
export ERL_AFLAGS="-kernel shell_history enabled"
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

typeset -U path
if [ -x "/Applications/Postgres.app/Contents/Versions/18/bin/psql" ]; then
    path=(
        /Applications/Postgres.app/Contents/Versions/18/bin
        $path
    )
elif [ -x "/Applications/Postgres.app/Contents/Versions/17/bin/psql" ]; then
    path=(
        /Applications/Postgres.app/Contents/Versions/17/bin
        $path
    )
fi

path=(
    $HOME/bin
    $HOME/.local/bin
    $HOME/.local/share/mise/shims
    $HOME/.cargo/bin
    $HOME/.fiberplane/bin
    $HOME/.maestro/bin
    $path
)

if [ -d "/Volumes/External" ]; then
    export DEV_BASE="/Volumes/External/dev/"
    export ANDROID_HOME="/Volumes/External/Library/Android/sdk"
    path=(
        "$ANDROID_HOME/emulator"
        "$ANDROID_HOME/platform-tools"
        $path
    )
else
    export DEV_BASE="$HOME/dev/"
fi

if [ -n "$HOMEBREW_PREFIX" ] && [ -x "$HOMEBREW_PREFIX/bin/brew" ]; then
    export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
    export HOMEBREW_REPOSITORY="$HOMEBREW_PREFIX/Homebrew"
    path=(
        "$HOMEBREW_PREFIX/bin"
        "$HOMEBREW_PREFIX/sbin"
        $path
    )
    export MANPATH="$HOMEBREW_PREFIX/share/man${MANPATH+:$MANPATH}:"
    export INFOPATH="$HOMEBREW_PREFIX/share/info:${INFOPATH:-}"
fi

export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && path=("$BUN_INSTALL/bin" $path)

[ -d "$HOME/.deno" ] && . "$HOME/.deno/env"

export PATH="${(j/:/)path}"
