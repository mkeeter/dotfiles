complete -x -c t -d "Session" -a "(tmux list-sessions 2> /dev/null | awk '{print substr(\$1, 1, length(\$1) - 1)}')"
