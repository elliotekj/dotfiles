# config.nu
#
# Installed by:
# version = "0.105.1"
#
# This file is used to override default Nushell settings, define
# (or import) custom commands, or run any other startup tasks.
# See https://www.nushell.sh/book/configuration.html
#
# This file is loaded after env.nu and before login.nu
#
# You can open this file in your default editor using:
# config nu
#
# See `help config nu` for more options
#
# You can remove these comments if you want or leave
# them for future reference.

$env.config.show_banner = false

$env.EDITOR = "hx"
$env.VISUAL = "hx"

$env.ERL_AFLAGS = "-kernel shell_history enabled"

alias phx = iex -S mix phx.server
alias g = gitu
alias c = claude --dangerously-skip-permissions --model opusplan

def prompt [] {
  let dir = (pwd | str replace $env.HOME "~")

  let branch = (
    do -i { git rev-parse --abbrev-ref HEAD } |
    complete |
    get stdout |
    str trim
  )

  let git = if ($branch | is-not-empty) { $" (ansi grey)($branch)(ansi reset)" } else { "" }

  $"($dir)($git)"
}

$env.PROMPT_COMMAND = { prompt }

def master [] {
  git checkout master
  git pull
  if ("mix.exs" | path exists) {
    mix deps.get
  }
}

def branch [branch_name: string] {
  if (git show-ref --verify --quiet $"refs/heads/($branch_name)" | complete | get exit_code) == 0 {
    print $"🎯 Existing branch '($branch_name)'..."
    git checkout $branch_name
    git pull origin $branch_name
  } else {
    print $"✨ New branch '($branch_name)'..."
    git checkout -b $branch_name
  }

  if ("mix.exs" | path exists) {
    mix deps.get
  }
}

def tc [] {
  let test_files = (
    git diff --name-only origin/master
    | lines 
    | where ($it | str ends-with "_test.exs")
  )
  
  if ($test_files | is-empty) {
    print "No test files found in changes"
  } else {
    print $"mix test ($test_files | str join ' ')"
    mix test ...$test_files
  }
}

def yank [file: path] {
  if ($file | path exists) {
    open $file | pbcopy
    print $"Yanked contents of '($file)' to clipboard."
  } else {
    print $"Error: '($file)' is not a valid file."
  }
}

def od [] {
    let today = (date now | format date "%Y-%m-%d")
    let obsidian_uri = $"obsidian://advanced-uri?vault=Elliot&daily=true&mode=new"
    
    open $obsidian_uri
    sleep 200ms
    
    let vault_path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot"
    let daily_notes_folder = "00 Daily"
    let daily_note_path = $"($vault_path)/($daily_notes_folder)/($today).md"
    
    hx $daily_note_path
}

source ~/.zoxide.nu
