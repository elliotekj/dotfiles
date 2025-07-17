# env.nu
#
# Installed by:
# version = "0.105.1"
#
# Previously, environment variables were typically configured in `env.nu`.
# In general, most configuration can and should be performed in `config.nu`
# or one of the autoload directories.
#
# This file is generated for backwards compatibility for now.
# It is loaded before config.nu and login.nu
#
# See https://www.nushell.sh/book/configuration.html
#
# Also see `help config env` for more options.
#
# You can remove these comments if you want or leave
# them for future reference.

$env.Path = ($env.Path | prepend '/opt/homebrew/bin')
$env.Path = ($env.Path | prepend ($env.HOME | path join '.local/bin'))
$env.Path = ($env.Path | prepend ($env.HOME | path join '.local/share/mise/shims'))

/opt/homebrew/bin/zoxide init nushell | save -f ~/.zoxide.nu

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
