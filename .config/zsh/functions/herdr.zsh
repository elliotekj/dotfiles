hid() {
    if [[ -z "${HERDR_PANE_ID:-}" ]]; then
        print -u2 -P '%F{red}hid: HERDR_PANE_ID is not set%f'
        return 1
    fi

    print -rn -- "$HERDR_PANE_ID" | pbcopy
}
