#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <input_file.xml|input_file.mxl|input_file.mscz>"
  exit 1
fi

INPUT_FILE="$1"

BASENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
SVG_FILE="${BASENAME}.svg"

echo "🎵 Converting $INPUT_FILE to SVG using MuseScore..."
mscore "$INPUT_FILE" -o "$SVG_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Error: MuseScore failed to process the file."
  exit 1
fi

echo "🧹 Sanitizing SVG for Dark Mode..."

# stripping the background is necessary for our dark mode hacks to work
sed -i.bak 's/fill="#ffffff"/fill="transparent"/gi' "$SVG_FILE"
sed -i.bak 's/fill="#FFFFFF"/fill="transparent"/gi' "$SVG_FILE"

sed -i.bak 's/fill="#000000"/fill="currentColor"/gi' "$SVG_FILE"
sed -i.bak 's/stroke="#000000"/stroke="currentColor"/gi' "$SVG_FILE"

rm "${SVG_FILE}.bak"

echo "✅ Success! Your dark-mode-ready SVG is ready: $SVG_FILE"
