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
$env.SSH_AUTH_SOCK = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

alias phx = iex -S mix phx.server
alias g = gitu
alias lg = lazygit
alias c = claude --dangerously-skip-permissions --model opusplan
alias j = just

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

def --env mkcd [path: string] {
    let expanded_path = ($path | path expand)
    mkdir $expanded_path
    cd $expanded_path
}

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

def fix [branch_name: string] {
  branch $"fix/($branch_name)"
}

def feat [branch_name: string] {
  branch $"feat/($branch_name)"
}

def tt [] {
    let test_files = (glob **/*_test.exs)
    
    if ($test_files | length) == 0 {
        print "No test files found ending in '_test.exs'"
        return
    }
    
    let cwd = (pwd)
    let relative_files = ($test_files | each { |file| 
        $file | str replace $"($cwd)/" ""
    })
    
    let selected_files = ($relative_files | str join "\n" | fzf --multi | lines)
    
    if ($selected_files | is-empty) {
        print "No files selected"
        return
    }
    
    print $"mix test ($selected_files | str join ' ')"
    mix test ...$selected_files
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

def open_daily_note [day_offset: int = 0] {
    let target_date = (date now) + ($day_offset * 1day) | format date "%Y-%m-%d"
    let obsidian_uri = "obsidian://advanced-uri?vault=Elliot&daily=true&mode=new"
    
    open $obsidian_uri
    sleep 200ms
    
    let vault_path = "~/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot"
    let daily_notes_folder = "00 Daily"
    let daily_note_path = $"($vault_path)/($daily_notes_folder)/($target_date).md"
    
    hx $daily_note_path
}

def od [] {
    open_daily_note 0
}

def ot [] {
    open_daily_note 1
}

source ~/.config/nushell_local/config.nu

source ~/.zoxide.nu
