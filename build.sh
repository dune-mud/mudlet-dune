#!/bin/sh

MUDDLE_PATH="${MUDDLE:-muddle}"

if command -v "$MUDDLE_PATH" >/dev/null 2>&1; then
  "$MUDDLE_PATH" "$@"
else
  echo "Error: $MUDDLE_PATH not found. Have you installed https://github.com/demonnic/muddler ?" >&2
  exit 1
fi
