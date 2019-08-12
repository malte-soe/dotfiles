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

set -x CONDA_LEFT_PROMPT
