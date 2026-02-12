#!/bin/bash

# Enable Chrome Insecure Origins for Local Development

# Create the list of insecure origins
INSECURE_ORIGINS=(
  "http://localhost"
  "http://localhost:8080"
  "http://127.0.0.1"
  "http://127.0.0.1:8080"
)

# Create a temporary file for the launch script
LAUNCH_SCRIPT="/tmp/chrome_insecure_origins.sh"

# Write the launch script
cat <<EOL > "$LAUNCH_SCRIPT"
#!/bin/bash

# Launch Chrome with the specified insecure origins
open -a "Google Chrome" --args --unsafely-treat-insecure-origin-as-secure=\
EOL

# Add each origin to the Chrome launch script
for ORIGIN in "${INSECURE_ORIGINS[@]}"; do
  echo "--unsafely-treat-insecure-origin-as-secure=$ORIGIN \" >> "$LAUNCH_SCRIPT"
done

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Create a launcher on the desktop
DESKTOP_LAUNCHER="~/Desktop/Launch_Chrome_Insecure_Origins.command"

cat <<EOL > "$DESKTOP_LAUNCHER"
#!/bin/bash

# Execute the script to launch Chrome
exec $LAUNCH_SCRIPT
EOL

# Make the launcher executable
chmod +x "$DESKTOP_LAUNCHER"

# Auto-start Chrome if not running
if ! pgrep -x "Google Chrome" > /dev/null; then
  open -a "Google Chrome"
fi

echo "Chrome launch script created on your Desktop!"