#!/bin/sh

./shell/list-audio-files.sh \
  | ./shell/without-a-transcript.sh \
  | cat | xargs -n1 -P 4 ./shell/transcribe.sh
