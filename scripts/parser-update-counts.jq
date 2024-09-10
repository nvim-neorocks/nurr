def revisions(file): reduce (file[0].parsers[] | {lang: .lang, rev: .install_info.revision}) as $item ({}; .[$item.lang] = $item.rev);

def count_updates(prev; curr; existing_counts):
  reduce (prev + curr | to_entries | map(.key) | unique | .[]) as $key (
    existing_counts;
    if (prev[$key] // null) == (curr[$key] // null) then
      # Preserve existing count or init as 1
      .[$key] = (existing_counts[$key] // 1)
    else
      .[$key] = (existing_counts[$key] // 0) + 1
    end
  );

revisions($prev) as $prev_revisions |
revisions($curr) as $curr_revisions |
count_updates($prev_revisions; $curr_revisions; $existing_counts) | to_entries | {update_counts: .}
