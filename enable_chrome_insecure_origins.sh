#!/bin/bash

# Enable insecure origins for Chrome on macOS
# This script modifies Chrome's security settings to allow insecure origins.

# Path to Chrome's plist file
PLIST_FILE=~/Library/Preferences/com.google.Chrome.plist

# Check if the plist file exists
if [ -f "$PLIST_FILE" ]; then
    # Set the flag to allow insecure origins
    /usr/bin/defaults write com.google.Chrome "InsecureOrigin" -bool true
    echo "Insecure origins are now enabled for Chrome."
else
    echo "Chrome is not installed or the preferences file does not exist."
    exit 1
}

# Launch Chrome
open -a "Google Chrome"
