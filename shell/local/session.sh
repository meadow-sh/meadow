#!/bin/bash

# Get the current timestamp


if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

session_data_dir="$data_dir/sessions/$timestamp"

mkdir "$session_data_dir"

# Use ffmpeg to record from the microphone
# Note: Replace "default" with your actual microphone device name if it's different
# ffmpeg -f avfoundation -i :0 -acodec pcm_s16le -ar 44100 -ac 2 $timestamp.wav

ffmpeg \
  -f avfoundation \
  -i :0 \
  -acodec pcm_s16le \
  -ac 2 \
  -ar 44100 \
  -f segment \
  -segment_time 30 \
  -segment_format wav \
  -segment_list "$session_data_dir/segments" \
  -reset_timestamps 1 \
  -map 0 \
  -c copy \
  "$session_data_dir/%03d.wav"
