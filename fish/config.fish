if not functions -q omf
    eval (curl -L https://get.oh-my.fish | fish)
end

bass source ~/.nix-profile/etc/profile.d/nix.sh

set -x IPYTHONDIR ~/.config/ipython
