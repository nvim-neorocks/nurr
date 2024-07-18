#!/usr/bin/env bash
# Assuming a prev.json, a copy of tree-sitter-parsers.json before updating:
#
# - Compares the revisions
# - Updates modified entries in ts-update-counts.json

if [[ -f resources/ts-update-counts.json ]]; then
  existing_counts=$(jq '.update_counts | from_entries' resources/ts-update-counts.json)
else
  existing_counts="{}"
fi

if ! echo "$existing_counts" | jq empty; then
  echo "Invalid JSON detected in ts-update-counts.json:"
  echo "$existing_counts"
  exit 1
fi

updates=$(jq -n -f scripts/ts-update-counts.jq --argjson existing_counts "$existing_counts" --slurpfile prev prev.json --slurpfile curr tree-sitter-parsers.json)

echo "$updates" | jq -S '{update_counts: .update_counts}' > resources/ts-update-counts.json
