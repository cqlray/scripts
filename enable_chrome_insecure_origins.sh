#!/bin/bash

# Enable Chrome to accept insecure origins on macOS

# Launch Chrome with the specified command-line flags
open -a "Google Chrome" --args --disable-web-security --user-data-dir="/tmp/chrome_dev"

# Insecure origins list
# Add the following domains:
# http://localhost
# http://localhost:8080
# http://127.0.0.1
# http://127.0.0.1:8080

 echo "Launched Chrome with insecure origins enabled for http://localhost, http://localhost:8080, http://127.0.0.1, and http://127.0.0.1:8080"