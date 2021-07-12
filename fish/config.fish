set fish_greeting



set -q XDG_CONFIG_HOME; or set XDG_CONFIG_HOME ~/.config

# no login shell
if status is-interactive
# not already in tmux session
and not set -q TMUX
    if test -z (tmux ls -f '#{==:#{session_name},$(USER)}}' -F '#{?session_attached,yes,}')
        exec tmux -u new -A -s $USER
    end
end

if command --search starship > /dev/null
    starship init fish | source
end

if command --search direnv > /dev/null
    eval (direnv hook fish)
end

