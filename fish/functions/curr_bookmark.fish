function curr_bookmark
  jj bookmark list -r 'trunk()..@' -T 'name++"\n"' | head -1
end
