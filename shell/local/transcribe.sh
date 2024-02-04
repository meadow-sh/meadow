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

current_dir=$(pwd)

for seg in $segments; do
  fn="/tmp/$(basename "$seg" .wav).16k.wav"
  rm -f "$fn"
  ffmpeg -loglevel error -i "$seg" -ar 16000 -ab 16 "$fn"
  
  #
  #
  # RUN FOR YOUR LIVES
  #
  #

  cd "$HOME/projects/personal/whisper.cpp" || exit

  rm -f "$fn.json"

  ./main -oj -f "$fn"
done

cd "$current_dir" || exit

