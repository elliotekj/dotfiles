export EDITOR="nvim"
export VISUAL="nvim"

# fzf Rose Pine theme
export FZF_DEFAULT_OPTS="
  --color=fg:#908caa,bg:#191724,hl:#ebbcba
  --color=fg+:#e0def4,bg+:#26233a,hl+:#ebbcba
  --color=info:#9ccfd8,prompt:#c4a7e7,pointer:#c4a7e7
  --color=marker:#a3be8c,spinner:#f6c177,header:#31748f
  --color=border:#6e6a86
"
export DFT_DISPLAY="side-by-side-show-both"
export ERL_AFLAGS="-kernel shell_history enabled"
export SSH_AUTH_SOCK="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

export PATH="/Applications/Postgres.app/Contents/Versions/17/bin:$PATH"
[ -d "$HOME/bin" ] && export PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"
[ -d "$HOME/.local/share/mise/shims" ] && export PATH="$HOME/.local/share/mise/shims:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

if [ -d "/Volumes/External" ]; then
    export DEV_BASE="/Volumes/External/dev/"
    export ANDROID_HOME="/Volumes/External/Library/Android/sdk"
    export PATH="$ANDROID_HOME/emulator:$PATH"
    export PATH="$ANDROID_HOME/platform-tools:$PATH"
else
    export DEV_BASE="$HOME/dev/"
fi

if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

[ -d "$HOME/.deno" ] && . "$HOME/.deno/env"
