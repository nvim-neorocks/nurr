#!/usr/bin/env bash
# Assuming a nvim-treesitter (main) is checked out, for each entry in resources/ts-update-counts.json,
#
# - Check the last commit date of the queries
# - If within the last 12 hours, increment the update count

echo "Checking for queries updates..."

# Load existing counts from update-count.json
existing_counts=$(jq '.update_counts | from_entries' resources/ts-update-counts.json)

updated_counts="$existing_counts"

local_run=false
while [[ "$#" -gt 0 ]]; do
  case $1 in
    --local) local_run=true ;;
    *) echo "Unknown parameter passed: $1"; exit 1 ;;
  esac
  shift
done

if [[ $local_run == true ]]; then
  echo "Running locally. Assuming nvim-treesitter is checked out in parent dir."
  pushd ../nvim-treesitter || exit 1
else
  pushd nvim-treesitter || exit 1
fi

# Parse the JSON and iterate over each key
for key in $(echo "$existing_counts" | jq -r 'keys[]'); do
  # Get the last commit date for the directory runtime/queries/<lang>
  # And increment the update count if it is within the last 12 hours
  if [[ -d "runtime/queries/$key" ]]; then
    commit_date=$(git log -1 --pretty="format:%ci" "runtime/queries/$key" 2>/dev/null)
    if [[ -n "$commit_date" ]]; then
      commit_timestamp=$(date -d "$commit_date" +%s)
      current_timestamp=$(date +%s)
      twelve_hours_ago=$((current_timestamp - 12 * 60 * 60))
      if [[ $commit_timestamp -gt $twelve_hours_ago ]]; then
        echo "tree-sitter-$key queries updated!"
        current_count=$(echo "$updated_counts" | jq -r --arg key "$key" '.[$key]')
        new_count=$((current_count + 1))
        updated_counts=$(echo "$updated_counts" | jq --arg key "$key" --argjson count "$new_count" '.[$key] = $count')
      fi
    fi
  fi
done

popd || exit 1

echo "$updated_counts" | jq -S 'to_entries | {update_counts: .}' > resources/ts-update-counts.json

echo "Done."
