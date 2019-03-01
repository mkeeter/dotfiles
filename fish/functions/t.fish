function t
    if count $argv > /dev/null
        z $argv; and tmux new-session -s $argv 2> /dev/null; or tmux attach -t $argv
    else
        tmux list-sessions
    end
end
