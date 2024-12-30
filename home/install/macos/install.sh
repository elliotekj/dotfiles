#!/bin/bash

set -eu

if [ "$(id -u)" -eq 0 ]; then
  echo "The script is running as root, please run as a the user."
  exit 1
fi

cd "$HOME"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_TOOLCHAINS_HOME="$HOME/.local/toolchains"

# -----------------------------------------------------------------------------
# Xcode Command Line Tools if needed
# -----------------------------------------------------------------------------

if [ ! -e "/Library/Developer/CommandLineTools/usr/bin/git" ]; then
  echo "Installing Xcode Command Line Tools"
  # This temporary file prompts the 'softwareupdate' utility to list the Command Line Tools
  clt_placeholder="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"
  sudo touch "$clt_placeholder"
  clt_label="$(/usr/sbin/softwareupdate -l | grep -B 1 -E 'Command Line Tools' | awk -F'*' '/^ *\*/ {print $2}' | sed -e 's/^ *Label: //' -e 's/^ *//' | sort -V | tail -n1)"
  if [[ -n $clt_label ]]; then
    echo "Installing $clt_label"
    sudo "/usr/sbin/softwareupdate" "-i" "$clt_label"
    sudo "/usr/bin/xcode-select" "--switch" "/Library/Developer/CommandLineTools"
  fi
  sudo rm -f "$clt_placeholder"
fi

export SDKROOT="/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk"

# -----------------------------------------------------------------------------
# Homebrew
# -----------------------------------------------------------------------------

brew=/opt/homebrew/bin/brew

if [ ! -x $brew ]; then
  echo "Install Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

$brew update
$brew bundle --file=$HOME/install/macos/Brewfile
$brew upgrade

export PATH="$brew":$PATH

# -----------------------------------------------------------------------------
# Rust
# -----------------------------------------------------------------------------

export CARGO_HOME="$XDG_TOOLCHAINS_HOME/rust/cargo"
export RUSTUP_HOME="$XDG_TOOLCHAINS_HOME/rust/rustup"
mkdir -p "$CARGO_HOME"
mkdir -p "$RUSTUP_HOME"
if ! command -v rustup &>/dev/null; then
  echo "Install rust..."
  curl -fsSL https://sh.rustup.rs | /bin/sh -s -- -y --no-modify-path
fi
"$CARGO_HOME"/bin/rustup default stable
"$CARGO_HOME"/bin/rustup component add rust-src rustfmt clippy

# -----------------------------------------------------------------------------
# ASDF
# -----------------------------------------------------------------------------

if [ ! -d "$HOME/.asdf" ]; then
  echo "Install asdf..."
  git clone https://github.com/asdf-vm/asdf.git $HOME/.asdf --branch v0.15.0
  . "$HOME/.asdf/asdf.sh"
fi

# TODO Remove once https://github.com/asdf-vm/asdf-erlang/issues/319 is resolved.
ulimit -n 65536

asdf plugin list | grep -q "^erlang$" || asdf plugin add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang latest
asdf global erlang latest
asdf plugin list | grep -q "^elixir$" || asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir latest
asdf global elixir latest
asdf plugin list | grep -q "^nodejs$" || asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf install nodejs latest
asdf global nodejs latest
export RUBY_CONFIGURE_OPTS="--with-zlib-dir=$($brew --prefix zlib) --with-openssl-dir=$($brew --prefix openssl@3) --with-readline-dir=$($brew --prefix readline) --with-libyaml-dir=$($brew --prefix libyaml)"
asdf plugin list | grep -q "^ruby$" || asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
asdf install ruby 3.3.5
asdf global ruby 3.3.5
asdf plugin list | grep -q "^python$" || asdf plugin add python https://github.com/asdf-community/asdf-python 
asdf install python 3.12.2
asdf install python 2.7.18
asdf global python 3.12.2 2.7.18
asdf plugin list | grep -q "^golang$" || asdf plugin add golang https://github.com/asdf-community/asdf-golang
asdf install golang latest
asdf global golang latest

# -----------------------------------------------------------------------------
# Config
# -----------------------------------------------------------------------------

chflags nohidden "$HOME/Library"
if [[ -d "$HOME/Applications" ]]; then
  chflags hidden "$HOME/Applications"
fi
if [[ -d "$HOME/Public" ]]; then
  chflags hidden "$HOME/Public"
fi

defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain AppleInterfaceStyle "Dark"

defaults write com.apple.dock show-recents -int 0
defaults write com.apple.dock autohide -int 1
defaults write com.apple.dock mru-spaces -bool false
defaults write com.apple.dock magnification -int 0
defaults write com.apple.dock mineffect "scale"
defaults write com.apple.dock minimize-to-application -int 1

defaults write com.apple.textedit RichText -int 0

# Remap Caps Lock as Control (see https://developer.apple.com/library/archive/technotes/tn2450/_index.html)
hidutil property --set '{
  "UserKeyMapping": [{
    "HIDKeyboardModifierMappingSrc": 0x700000039,
    "HIDKeyboardModifierMappingDst": 0x7000000E0,
  }]
}'

# Make sure that Spotify doesn't start on login...
mkdir -p "$HOME/Library/Application\ Support/Spotify"
touch "$HOME/Library/Application\ Support/Spotify/prefs"
if ! grep -q "app.autostart-mode" "$HOME/Library/Application\ Support/Spotify/prefs"; then
  echo 'app.autostart-mode="off"' >>"$HOME/Library/Application\ Support/Spotify/prefs"
  echo 'app.autostart-banner-seen=true' >>"$HOME/Library/Application\ Support/Spotify/prefs"
fi

killall Finder
killall Dock

printf "\e[1;32m==> Done! You should now reboot.\n\e[0m"

