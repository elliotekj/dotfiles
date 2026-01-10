tt() {
    local test_files
    test_files=$(find . -name "*_test.exs" -type f 2>/dev/null)

    if [ -z "$test_files" ]; then
        echo "No test files found ending in '_test.exs'"
        return
    fi

    local selected_files
    selected_files=$(echo "$test_files" | fzf --multi)

    if [ -z "$selected_files" ]; then
        echo "No files selected"
        return
    fi

    local files_arg
    files_arg=$(echo "$selected_files" | tr '\n' ' ')

    echo "mix test $files_arg"
    eval "mix test $files_arg"
}

tc() {
    local test_files
    test_files=$(git diff --name-only origin/master | grep '_test\.exs$')

    if [ -z "$test_files" ]; then
        echo "No test files found in changes"
    else
        local files_arg
        files_arg=$(echo "$test_files" | tr '\n' ' ')
        echo "mix test $files_arg"
        eval "mix test $files_arg"
    fi
}
