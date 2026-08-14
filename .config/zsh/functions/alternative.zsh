_a_find_directory() {
    local parent="$1"
    local desired="$2"
    local candidate
    local desired_lower="${desired:l}"
    local case_insensitive_match

    setopt localoptions nullglob
    for candidate in "$parent"/*; do
        [[ -d "$candidate" ]] || continue
        if [[ "${candidate:t}" == "$desired" ]]; then
            print -r -- "$candidate"
            return 0
        fi
        if [[ -z "$case_insensitive_match" && "${candidate:t:l}" == "$desired_lower" ]]; then
            case_insensitive_match="$candidate"
        fi
    done

    [[ -n "$case_insensitive_match" ]] && print -r -- "$case_insensitive_match" && return 0
    return 1
}

a() {
    local current_name="${PWD:t}"
    local current_lower="${current_name:l}"
    local parent="${PWD:h}"
    local alternate_name
    local target

    if [[ "${parent:t:l}" == *.worktrees ]]; then
        local worktree_parent="${parent:h}"
        local worktree_root_name="${parent:t:l}"
        local base_name="${worktree_root_name%.worktrees}"
        local alternate_base
        local alternate_worktree_root
        local alternate_worktree_path

        if [[ "$base_name" == *_api ]]; then
            alternate_base="${base_name%_api}"
        else
            alternate_base="${base_name}_api"
        fi

        alternate_worktree_root="${alternate_base}.worktrees"

        if alternate_worktree_path=$(_a_find_directory "$worktree_parent" "$alternate_worktree_root"); then
            if target=$(_a_find_directory "$alternate_worktree_path" "$current_name"); then
                builtin cd -- "$target"
                return $?
            fi
        fi

        if target=$(_a_find_directory "$worktree_parent" "$alternate_base"); then
            builtin cd -- "$target"
            return $?
        fi
    else
        if [[ "$current_lower" == *_api ]]; then
            alternate_name="${current_lower%_api}"
        else
            alternate_name="${current_lower}_api"
        fi

        if target=$(_a_find_directory "$parent" "$alternate_name"); then
            builtin cd -- "$target"
            return $?
        fi
    fi

    print -u2 -r -- "a: no alternate directory for $PWD"
    return 1
}
