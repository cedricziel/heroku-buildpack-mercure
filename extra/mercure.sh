#!/usr/bin/env bash

export PATH="$PATH:$HOME/bin"

APP_MERCURE="/app/mercure"

PRERUN_SCRIPT="$APP_MERCURE/prerun.sh"
if [ -e "$PRERUN_SCRIPT" ]; then
  source "$PRERUN_SCRIPT"
fi

if [ -n "$DISABLE_MERCURE" ]; then
  echo "The Mercure Hub agent has been disabled. Unset the $DISABLE_MERCURE variable or set missing environment variables."
else
  bash -c "mercure $MERCURE_ARGS 2>&1 &"
fi
