set fish_greeting



set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

if test -f ~/.nix-profile/etc/profile.d/nix.sh
and functions -q bass
    bass source ~/.nix-profile/etc/profile.d/nix.sh
end

if status is-interactive
and not set -q TMUX
    exec tmux -u new -A -s $USER
end

if command --search starship > /dev/null
    starship init fish | source
end

if command --search direnv > /dev/null
    eval (direnv hook fish)
end

if test -f ~/miniconda3/bin/conda
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    eval ~/miniconda3/bin/conda "shell.fish" "hook" $argv | source
    # <<< conda initialize <<<
end

