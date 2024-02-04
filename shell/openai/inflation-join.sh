#!/bin/sh

filename="$1"
parsed="/tmp/parsed.txt"
./shell/transcript-parse.sh "$filename" > "$parsed"
total_lines=$(wc -l < "$parsed")
start_line=1

while (( start_line <= total_lines )); do
  end_line=$((start_line + 19))

  echo; echo "***BEGIN ORIGINAL***"; echo

  sed -n "$start_line,$end_line p; $end_line q" "$parsed"

  echo; echo "***END ORIGINAL***"; echo

  echo; echo "***BEGIN INFLATION***"; echo

  ./shell/chat-completion-parse.sh "$filename.$end_line.inflated.json"

  echo; echo "***END INFLATION***"; echo

  echo; echo "***BEGIN PATCH***"; echo

  ./shell/chat-completion-parse.sh "$filename.$end_line.inflation.patch.json"

  echo; echo "***END PATCH***"; echo

  start_line=$((end_line + 1))
done