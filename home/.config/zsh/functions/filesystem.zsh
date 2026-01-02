mkcd() {
    if [ -z "$1" ]; then
        echo "Usage: mkcd <path>"
        return 1
    fi
    mkdir -p "$1" && cd "$1"
}

mktouch() {
    if [ -z "$1" ]; then
        echo "Usage: mktouch <path>"
        return 1
    fi
    local dir=$(dirname "$1")
    mkdir -p "$dir" && touch "$1"
}

yank() {
    if [ -f "$1" ]; then
        pbcopy < "$1"
        echo "Yanked contents of '$1' to clipboard."
    else
        echo "Error: '$1' is not a valid file."
    fi
}
