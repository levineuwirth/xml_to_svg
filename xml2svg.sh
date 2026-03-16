#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <input_file.xml|input_file.mxl>"
  exit 1
fi

INPUT_FILE="$1"

BASENAME=$(basename "$INPUT_FILE" | sed 's/\.[^.]*$//')
LY_FILE="${BASENAME}.ly"

echo "🎵 Converting $INPUT_FILE to LilyPond format..."
musicxml2ly "$INPUT_FILE" -o "$LY_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Error: musicxml2ly failed to process the file."
  exit 1
fi

echo "🧹 Stripping metadata (title, composer, tagline)..."
cat << 'EOF' >> "$LY_FILE"

\header {
  title = ##f
  subtitle = ##f
  composer = ##f
  arranger = ##f
  poet = ##f
  tagline = ##f
}
EOF

echo "🎨 Compiling cropped SVG..."
lilypond --svg -dcrop "$LY_FILE"

if [ $? -ne 0 ]; then
  echo "❌ Error: LilyPond failed to compile the SVG."
  exit 1
fi

echo "🗑️ Cleaning up intermediate files..."
rm "$LY_FILE"
rm "${BASENAME}.svg"

echo "✅ Success! Your clean, cropped SVG is ready: ${BASENAME}.cropped.svg"
