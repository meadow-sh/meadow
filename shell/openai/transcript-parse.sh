#!/bin/sh

if [ ! -f "$1" ]; then
  echo "Usage: $0 <transcript file>"
  exit 1
fi

jq .text -r < "$1" | fold -s -w 80

