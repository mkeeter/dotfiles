# when you accidentally edit revision with a pushed bookmark, this puts the
# changes in a new commit and resets the bookmark to the origin version
function jsr
    set --local b (curr_bookmark)
    jj new "$b"@origin
    jj restore -f "$b"
    jj abandon "$b"
    jj bookmark set "$b" -r "$b"@origin
end
