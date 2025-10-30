#!/bin/bash
set -e

# Start Tailscale daemon in the background
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock &

# Wait for tailscaled to start
echo "Waiting for tailscaled to start"
sleep 5

# Authenticate with Tailscale if auth key is provided
if [ -n "$TAILSCALE_AUTHKEY" ]; then
    tailscale up --authkey="$TAILSCALE_AUTHKEY" ${TAILSCALE_ARGS:-}
else
    echo "Warning: TAILSCALE_AUTHKEY not set. Tailscale will not authenticate automatically."
    tailscale up ${TAILSCALE_ARGS:-}
fi

# Execute the original LinuxServer Plex entrypoint
echo "Tailscale up, starting Plex..."
exec /init
