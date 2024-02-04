#!/bin/bash

timestamp=$(date +"%Y-%m-%d")

if [ -z "$MEADOW_DATA_DIR" ]; then
  data_dir="$HOME/.meadow/data"
else
  data_dir="$MEADOW_DATA_DIR"
fi

rm -f /tmp/today.md

while read -r file; do
  {
    echo "# $(basename "$file")"
    echo ""
    cat "$file"
    echo ""
  } >> /tmp/today.md
done < <(find "$data_dir/notebook" -type f -name "$timestamp*.md")


# chmod u-w /tmp/today.md

# idk if readonly is a real thing
code /tmp/today.md

