#!/bin/sh

if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

npx nodemon -w "$data_dir" --ext .wav --exec "./local/transcribe-last-completed.sh 2>/dev/null"