set fish_greeting



set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config


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

