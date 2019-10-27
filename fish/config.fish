if test -f ~/.nix-profile/etc/profile.d/nix.sh
    bass source ~/.nix-profile/etc/profile.d/nix.sh
end

set -x IPYTHONDIR ~/.config/ipython

if status is-interactive
and not set -q TMUX
    exec tmux new -A -s $USER
end
