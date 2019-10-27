if not functions -q omf
    eval (curl -L https://get.oh-my.fish | fish)
end

bass source ~/.nix-profile/etc/profile.d/nix.sh

set -x IPYTHONDIR ~/.config/ipython

if status is-interactive
and not set -q TMUX
    exec tmux new -A -s $USER
end
