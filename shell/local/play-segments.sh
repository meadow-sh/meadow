#!/bin/sh

if [ -z "$1" ]; then
  echo "Usage: $0 <number>"
  exit 1
fi

if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

# note if there's concurrent sessions this will multiplex the segments.
segments=$(find "$data_dir/sessions" -type f -name "*.wav" -exec stat -f='%B %N' {} + | sort -n | tail -n "$1" | cut -d' ' -f2)

for seg in $segments; do
  echo "Playing $seg"
  ffplay -autoexit "$seg"
done

