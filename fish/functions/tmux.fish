# Defined in - @ line 1
function tmux --description 'alias tmux tmux -u -f ~/.config/tmux/tmux.conf'
	command tmux -u -f ~/.config/tmux/tmux.conf $argv;
end
