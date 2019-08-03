if not functions -q fundle
    eval (curl -sfL https://git.io/fundle-install)
end

fundle plugin 'edc/bass'
fundle plugin 'franciscolourenco/done'
fundle plugin 'fishpkg/fish-humanize-duration'
fundle init
if test -e ~/.bash_profile
    bass source ~/.bash_profile
end

set -x IPYTHONDIR ~/.config/ipython

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
eval /Users/malte/miniconda3/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<
set -x CONDA_LEFT_PROMPT
