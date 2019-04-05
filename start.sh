#!/bin/bash

export MIX_ENV=prod
export PORT=4797
export HOME=/home/project2/project2

echo "Stopping old copy of app, if any..."

/home/project2/project2/_build/prod/rel/project2/bin/project2 stop || true

echo "Starting app..."

# Start to run in background from shell.
#_build/prod/rel/memory/bin/memory start

# Foreground for testing and for systemd
/home/project2/project2/_build/prod/rel/project2/bin/project2 foreground

# DONE: Add a cron rule or systemd service file
#       to start your app on system boot.

