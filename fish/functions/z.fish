function z -d "jump around"
  set -l target (zipzap --quiet find $argv)
  set -l Z_STATUS $status
  if test $Z_STATUS -eq 0; and test -n "$target"
    builtin cd "$target"
  end
  return $Z_STATUS
end
