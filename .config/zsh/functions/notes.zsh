_open_daily_note() {
    local day_offset="${1:-0}"
    local target_date
    target_date=$(date -v+"${day_offset}d" "+%Y-%m-%d")

    local obsidian_uri="obsidian://advanced-uri?vault=Elliot&daily=true&mode=new"

    open "$obsidian_uri"
    sleep 0.2

    local vault_path="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot"
    local daily_notes_folder="00 Daily"
    local daily_note_path="$vault_path/$daily_notes_folder/$target_date.md"

    $EDITOR "$daily_note_path"
}

od() {
    _open_daily_note 0
}

ot() {
    _open_daily_note 1
}

wtn() {
    local parent
    parent=$(_get_parent_project)

    local branch_name
    branch_name=$(git branch --show-current)
    local dir_name="${branch_name//\//-}"
    local note_name="worktree-${parent}-${dir_name}"

    local vault_path="$HOME/Library/Mobile Documents/iCloud~md~obsidian/Documents/Elliot"
    local note_path="$vault_path/$note_name.md"

    $EDITOR "$note_path"
}
