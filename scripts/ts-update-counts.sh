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

updates=$(jq -n --argjson existing_counts "$existing_counts" --slurpfile prev prev.json --slurpfile curr tree-sitter-parsers.json '
  def revisions(file): reduce (file[0].parsers[] | {lang: .lang, rev: .install_info.revision}) as $item ({}; .[$item.lang] = $item.rev);
  def count_updates(prev; curr; existing_counts):
    reduce (prev + curr | to_entries | map(.key) | unique | .[]) as $key (
      existing_counts;
      if (prev[$key] // null) != (curr[$key] // null) then
        .[$key] = (existing_counts[$key] // 0) + 1
      else
        .[$key] = 1
      end
    );
  revisions($prev) as $prev_revisions |
  revisions($curr) as $curr_revisions |
  count_updates($prev_revisions; $curr_revisions; $existing_counts) | to_entries | {update_counts: .}
')

echo "$updates" | jq -S '{update_counts: .update_counts}' > resources/ts-update-counts.json
