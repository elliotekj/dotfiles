export EDITOR="nvim"
export VISUAL="nvim"

# fzf Solarized Light theme
export FZF_DEFAULT_OPTS="
  --color=fg:#657b83,bg:#fdf6e3,hl:#268bd2
  --color=fg+:#586e75,bg+:#eee8d5,hl+:#268bd2
  --color=info:#2aa198,prompt:#d33682,pointer:#d33682
  --color=marker:#859900,spinner:#cb4b16,header:#93a1a1
  --color=border:#93a1a1
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

if [ "$(uname -m)" = "arm64" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    eval "$(/usr/local/bin/brew shellenv)"
fi

export BUN_INSTALL="$HOME/.bun"
[ -d "$BUN_INSTALL" ] && export PATH="$BUN_INSTALL/bin:$PATH"

[ -d "$HOME/.deno" ] && . "$HOME/.deno/env"
