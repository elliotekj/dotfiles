#!/bin/bash
# Wrapper for offlineimap that sends notifications for new mail

before=$(ls -1 ~/Mail/gmail/inbox/new 2>/dev/null | wc -l | tr -d ' ')

/opt/homebrew/bin/offlineimap -q

after=$(ls -1 ~/Mail/gmail/inbox/new 2>/dev/null | wc -l | tr -d ' ')

new_count=$((after - before))
if [[ $new_count -gt 0 ]]; then
    osascript -e "display notification \"$new_count new message(s)\" with title \"Mail\""
fi
