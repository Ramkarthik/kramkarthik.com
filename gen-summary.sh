#!/bin/bash

# Usage: ./generate-summary.sh <filename>
# Example: ./generate-summary.sh my-post.md
# Reads the file from src/content/posts/, generates a <160 char summary
# using OpenAI GPT-4o-mini, and writes it to the frontmatter "summary" field.

set -e

# ── Config ────────────────────────────────────────────────────────────────────
POSTS_DIR="src/content/posts"

# ── Validate input ────────────────────────────────────────────────────────────
if [[ -z "$1" ]]; then
  echo "Error: No filename provided."
  echo "Usage: $0 <filename>"
  exit 1
fi

if [[ -z "$OPENAI_API_KEY" ]]; then
  echo "Error: OPENAI_API_KEY environment variable is not set."
  exit 1
fi

FILE_PATH="$POSTS_DIR/$1"

if [[ ! -f "$FILE_PATH" ]]; then
  echo "Error: File not found: $FILE_PATH"
  exit 1
fi

echo "Processing: $FILE_PATH"

# ── Read file content ─────────────────────────────────────────────────────────
FILE_CONTENT=$(cat "$FILE_PATH")

# Strip frontmatter (between --- delimiters) to get the body text only
BODY=$(awk '/^---/{i++; next} i==1{next} {print}' "$FILE_PATH")

if [[ -z "$BODY" ]]; then
  echo "Error: Could not extract body content from $FILE_PATH"
  exit 1
fi

# ── Call OpenAI API ───────────────────────────────────────────────────────────
echo "Generating summary via OpenAI gpt-4o-mini..."

# Build JSON payload safely using Python to avoid any escaping issues
JSON_PAYLOAD=$(echo "$BODY" | head -c 4000 | python3 -c "
import sys, json
body = sys.stdin.read()
payload = {
    'model': 'gpt-4o-mini',
    'max_tokens': 80,
    'messages': [
        {
            'role': 'system',
            'content': 'You generate concise blog post summaries. Return ONLY the summary text — no quotes, no labels, no extra text. The summary must be under 160 characters. It should capture the essence of the post and entice readers to click through.'
        },
        {
            'role': 'user',
            'content': body
        }
    ]
}
print(json.dumps(payload))
")

RESPONSE=$(curl -s https://api.openai.com/v1/chat/completions \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d "$JSON_PAYLOAD")

# Extract summary from response
SUMMARY=$(echo "$RESPONSE" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'error' in data:
    print('ERROR:' + data['error']['message'])
else:
    print(data['choices'][0]['message']['content'].strip())
")

# Check for API error
if [[ "$SUMMARY" == ERROR:* ]]; then
  echo "OpenAI API error: ${SUMMARY#ERROR:}"
  exit 1
fi

# Trim to 160 chars just in case
SUMMARY="${SUMMARY:0:160}"
echo "Generated summary: $SUMMARY"

# ── Update frontmatter ────────────────────────────────────────────────────────
# Check if a "summary:" field already exists in frontmatter
HAS_SUMMARY=$(awk '/^---/{i++} i==1 && /^summary:/{print "yes"; exit}' "$FILE_PATH")

if [[ "$HAS_SUMMARY" == "yes" ]]; then
  # Replace existing summary field
  python3 -c "
import re, sys

file_path = sys.argv[1]
new_summary = sys.argv[2]

with open(file_path, 'r') as f:
    content = f.read()

# Match the summary line inside the first frontmatter block
# Handles both 'summary: value' and 'summary: \"value\"'
updated = re.sub(
    r'(?m)(^summary:\s*).*$',
    lambda m: m.group(1) + '\"' + new_summary + '\"',
    content,
    count=1
)

with open(file_path, 'w') as f:
    f.write(updated)

print('Updated existing summary field.')
" "$FILE_PATH" "$SUMMARY"

else
  # Insert summary field after the opening ---
  python3 -c "
import sys

file_path = sys.argv[1]
new_summary = sys.argv[2]

with open(file_path, 'r') as f:
    lines = f.readlines()

# Find the closing --- of the frontmatter and insert before it
in_frontmatter = False
insert_at = None
for i, line in enumerate(lines):
    stripped = line.strip()
    if stripped == '---':
        if not in_frontmatter:
            in_frontmatter = True
        else:
            insert_at = i
            break

if insert_at is None:
    print('Error: Could not find frontmatter block.')
    sys.exit(1)

lines.insert(insert_at, f'summary: "{new_summary}"\n')

with open(file_path, 'w') as f:
    f.writelines(lines)

print('Inserted new summary field into frontmatter.')
" "$FILE_PATH" "$SUMMARY"

fi

echo "Done! Summary written to: $FILE_PATH"