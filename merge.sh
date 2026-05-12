#!/bin/bash

set -e

OUTPUT="merged.txt"
TEMP="temp.txt"

echo "Start merging blocklists..."

> $TEMP

while read -r url; do
  echo "Fetching: $url"
  curl -sL "$url" >> $TEMP || echo "Failed: $url"
  echo "" >> $TEMP
done < sources.txt

echo "Cleaning..."

# buang comment & empty line
grep -v '^#' $TEMP | grep -v '^$' > cleaned.txt

# extract domain aja (biar ringan & konsisten)
grep -Eo '([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}' cleaned.txt \
  | tr '[:upper:]' '[:lower:]' \
  | sort -u > $OUTPUT

rm -f $TEMP cleaned.txt

echo "Done → $OUTPUT"
