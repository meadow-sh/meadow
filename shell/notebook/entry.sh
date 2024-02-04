#!/bin/sh

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

code "$data_dir/notebook/$timestamp.md"