#!/bin/sh


while read file; do
  if [ -f "$file".txt ]; then
    continue
  else
    echo "$file"
  fi
done < "${1:-/dev/stdin}"
