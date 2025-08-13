function curr_bookmark
  jj bookmark list --tracked -r 'trunk()..@' -T 'name++"\n"' | head -1
end
