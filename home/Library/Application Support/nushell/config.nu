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

#######################################################################
# Generic
#######################################################################

$env.config.show_banner = false

$env.EDITOR = "hx"
$env.VISUAL = "hx"
$env.ERL_AFLAGS = "-kernel shell_history enabled"
$env.SSH_AUTH_SOCK = "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"

alias c = claude --dangerously-skip-permissions --model opusplan
alias g = gitu
alias j = just
alias lg = lazygit
alias phx = iex -S mix phx.server
alias tsn = tmux new -s 

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

#######################################################################
# Filesystem
#######################################################################

def --env mkcd [path: string] {
    let expanded_path = ($path | path expand)
    mkdir $expanded_path
    cd $expanded_path
}

def --env mktouch [path: string] {
    let expanded_path = ($path | path expand)
    let filename = ($expanded_path | path basename)
    let dir_path = ($expanded_path | path dirname)
    
    mkdir $dir_path
    touch $expanded_path
}

def yank [file: path] {
  if ($file | path exists) {
    open $file | pbcopy
    print $"Yanked contents of '($file)' to clipboard."
  } else {
    print $"Error: '($file)' is not a valid file."
  }
}

#######################################################################
# Git
#######################################################################

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

def _get_parent_project [] {
  let origin = (git config --get remote.origin.url)

  $origin
  | str replace --regex '.*[/:]' ''      # Get everything after last / or :
  | str replace --regex '\.[^.]*$' ''    # Remove extension (last . and everything after)
}

def --env _setup_worktree [worktree_path: string, parent: string] {
  cd $worktree_path

  mix deps.get

  let env_file = ($"../($parent)/.env" | path expand)
  if ($env_file | path exists) {
    cp $env_file .
  }
}

def --env mkwt [name: string] {
  let parent = (_get_parent_project)

  let dir_name = ($name | str replace --all '/' '-')
  let worktree_path = ($"../worktree-($parent)-($dir_name)" | path expand)

  git worktree add -b $name $worktree_path
  _setup_worktree $worktree_path $parent

  print $"Worktree created at ($worktree_path) with branch ($name)"
}

def --env cowt [branch_name: string] {
  let parent = (_get_parent_project)

  let dir_name = ($branch_name | str replace --all '/' '-')
  let worktree_path = ($"../worktree-($parent)-($dir_name)" | path expand)

  git worktree add $worktree_path $branch_name

  _setup_worktree $worktree_path $parent

  print $"Worktree created at ($worktree_path) checking out branch ($branch_name)"
}

def --env rmwt [] {
    let current_dir = ($env.PWD)
    let branch_name = (git branch --show-current)
    
    # Check if we're in a worktree by checking if .git is a file (not a directory)
    # In worktrees, .git is a file that points to the main repo
    # In the main repo, .git is a directory
    let git_path = ($current_dir | path join ".git")
    
    if not ($git_path | path exists) {
        error make { msg: "Not in a git repository." }
    }
    
    if ($git_path | path type) == "dir" {
        error make { msg: "Not in a worktree directory. This command must be run from within a worktree." }
    }
    
    print $"This will delete:"
    print $"  - Worktree: ($current_dir)"
    print $"  - Branch: ($branch_name)"
    print ""
    
    let confirm = (input "Are you sure you want to proceed? (yes/no): ")
    
    if ($confirm | str downcase) != "yes" {
        print "Deletion cancelled."
        return
    }

    let parent = (_get_parent_project)
    
    cd $"../($parent)"

    let remove_result = (git worktree remove $current_dir | complete)

    if $remove_result.exit_code != 0 {
        if ($remove_result.stderr | str contains "Permission denied") {
            print "Permission denied. Requesting elevated privileges..."

            let sudo_result = (sudo rm -rf $current_dir | complete)

            if $sudo_result.exit_code != 0 {
                print $"Error removing worktree with sudo: ($sudo_result.stderr)"
                return
            }

            git worktree remove $current_dir
        } else {
            print $"Error removing worktree: ($remove_result.stderr)"
            return
        }
    }

    git branch -D $branch_name

    print $"Deleted worktree at ($current_dir) and branch ($branch_name)"
}

#######################################################################
# Elixir
#######################################################################

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

#######################################################################
# Notes
#######################################################################

def _open_daily_note [day_offset: int = 0] {
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
    _open_daily_note 0
}

def ot [] {
    _open_daily_note 1
}

#######################################################################
# Tmux
#######################################################################

def tsa [session_name?: string] {
    let sessions_result = (tmux ls | complete)
    
    if $sessions_result.exit_code != 0 {
        print "No tmux sessions found"
        return
    }
    
    let sessions = ($sessions_result.stdout | lines | split column ': ' | get column1)
    
    if ($sessions | is-empty) {
        print "No tmux sessions found"
        return
    }
    
    if ($session_name | is-not-empty) {
        if ($session_name in $sessions) {
            tmux attach -t $session_name
        } else {
            print $"Session '($session_name)' not found"
        }
        return
    }
    
    let selected = ($sessions | str join "\n" | fzf --prompt "Select tmux session: " --height 40%)
    
    if ($selected | is-not-empty) {
        tmux attach -t $selected
    }
}

#######################################################################
# Pre-flight
#######################################################################

source ~/.config/nushell_local/config.nu

source ~/.zoxide.nu
