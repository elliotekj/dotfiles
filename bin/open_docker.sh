#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Docker
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖

# Documentation:
# @raycast.description Open Docker dashboard
# @raycast.author elliotekj
# @raycast.authorURL https://raycast.com/elliotekj

osascript <<EOF
tell application "Docker Desktop" to reopen
delay 0.5
tell application "Docker Desktop" to activate
EOF
