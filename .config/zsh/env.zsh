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

export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/share/mise/shims" ] && export PATH="$HOME/.local/share/mise/shims:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.fiberplane/bin" ] && export PATH="$HOME/.fiberplane/bin:$PATH"

if [ -d "/Volumes/External" ]; then
    export DEV_BASE="/Volumes/External/dev/"
    export ANDROID_HOME="/Volumes/External/Library/Android/sdk"
    export PATH="$ANDROID_HOME/emulator:$PATH"
    export PATH="$ANDROID_HOME/platform-tools:$PATH"
else
    export DEV_BASE="$HOME/dev/"
fi

if [ -n "$HOMEBREW_PREFIX" ] && [ -x "$HOMEBREW_PREFIX/bin/brew" ]; then
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
fi

export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

[ -d "$HOME/.deno" ] && . "$HOME/.deno/env"
