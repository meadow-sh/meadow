#!/bin/sh

if [ -z $1 ]; then
  echo "Usage: $0 <completion file>"
  exit 1
fi

cat "$1" | jq '.choices[0].message.content' -r