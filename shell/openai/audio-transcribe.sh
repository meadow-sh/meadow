#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 <audio file>"
  exit 1
fi

if [ -z $OPEN_AI_API_KEY ]; then
  echo "OPEN_AI_API_KEY is not set"
  exit 1
fi

curl \
  -s \
  --request POST \
  --url https://api.openai.com/v1/audio/transcriptions \
  --header "Authorization: Bearer $OPEN_AI_API_KEY" \
  --header 'Content-Type: multipart/form-data' \
  --form language=en \
  --form file=@${1} \
  --form model=whisper-1 > ${1}.txt