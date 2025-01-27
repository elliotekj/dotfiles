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

arch_name="$(uname -m)"
if [ "${arch_name}" = "arm64" ]; then
  brew=/opt/homebrew/bin/brew
else
  brew=/usr/local/bin/brew
fi

if [ ! -x $brew ]; then
  echo "Install Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

$brew update
$brew bundle --file=$HOME/install/macos/Brewfile
$brew upgrade

export PATH="$brew":$PATH

# -----------------------------------------------------------------------------
# Tooling
# -----------------------------------------------------------------------------

curl https://mise.run | sh
curl -LsSf https://astral.sh/uv/install.sh | sh

# -----------------------------------------------------------------------------
# Apps
# -----------------------------------------------------------------------------

# Amphetamine
mas install 937984704

# Things
mas install 904280696

# Transporter
mas install 1450874784

# -----------------------------------------------------------------------------
# Config
# -----------------------------------------------------------------------------

cp ~/Library/Mobile\ Documents/com~apple~CloudDocs/Fonts/TX-02-Variable.otf ~/Library/Fonts/

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
defaults write com.apple.dock persistent-apps -array

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

# Setup homeshick
rm -rf "$HOME/install"
$($brew --prefix homeshick)/bin/homeshick clone elliotekj/dotfiles
cd "$HOME/.homesick/repos/dotfiles/" && git remote set-url origin git@github.com:elliotekj/dotfiles.git && cd "$HOME"

killall Finder
killall Dock

printf "\e[1;32m==> Done! You should now reboot.\n\e[0m"

