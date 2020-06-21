#!/usr/bin/env bash

POLYBAR="$(command -v polybar 2>/dev/null)"

if [ -z "$POLYBAR" ]; then
    echo "polybar is not installed"
    exit 1
fi

# Kill existing polybar instances
killall -q polybar

# Launch new polybar instances
"$POLYBAR" main > /dev/null 2>&1 &
