#!/bin/sh

if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

# note if there's concurrent sessions this will multiplex the segments.
seg=$(find "$data_dir/sessions" -type f -name "*.wav" -exec stat -f='%B %N' {} + | sort -n | tail -n 2 | head -n 1 | cut -d' ' -f2)

current_dir=$(pwd)

fn="/tmp/live.wav"
rm -f "$fn"
ffmpeg -loglevel error -i "$seg" -ar 16000 -ab 16 "$fn"

#
#
# RUN FOR YOUR LIVES
#
#

cd "$HOME/projects/personal/whisper.cpp" || exit

./main -oj -f "$fn"

jq .transcript[].text $fn.json

cd "$current_dir" || exit

