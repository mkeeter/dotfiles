function t
	z $argv; and tmux new-session -s $argv; or tmux attach -t $argv
end
