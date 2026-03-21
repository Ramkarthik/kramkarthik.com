#!/bin/bash

# Exit on error
set -e

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <post-type> <title>"
  exit 1
fi

# Configuration
TARGET_DIR="./src/content/posts"
DATE=$(date -u +%s)
DATE=$((DATE + 120*60))
DATE=$(date -u -r "$DATE" +"%Y-%m-%dT%H:%M:%S.000Z")
SLUG=$(echo "$2" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
FILENAME="$SLUG.mdx"
FILEPATH="$TARGET_DIR/$FILENAME"
STARTDATE="2026-03-06"
DATENUMBER=$(python3 -c "from datetime import date; print((date.today() - date.fromisoformat('$STARTDATE')).days)")

# Prevent overwriting an existing file
if [ -f "$FILEPATH" ]; then
  echo "File already exists: $FILEPATH"
  exit 1
fi

# Create markdown file with prefilled headers
cat <<EOF > "$FILEPATH"
---
title: "$2"
category: "$1"
createdDate: "$DATE"
modifiedDate: "$DATE"
tags: ["100DaysToOffload"]
garden: "seedling"
summary: ""
---
import HundredDaysToOffload from '../../components/HundredDaysToOffload.astro';

// Fill in the postNumber and dayNumber

<HundredDaysToOffload postNumber={} dayNumber={$DATENUMBER} />
EOF


echo "New post created: $FILEPATH"
