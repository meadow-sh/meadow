#!/bin/sh

if [ ! -f "$1" ]; then
  echo "Usage: $0 <transcript file>"
  exit 1
fi

./shell/audio-transcribe.sh "$1"

./shell/transcript-inflate.sh "$1.txt"

./shell/inflation-patch.sh "$1.txt"