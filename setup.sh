set -e
cd "$HOME/.config"
git init
git remote add origin https://github.com/malte-soe/dotfiles.git
git pull origin master

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh -b

$HOME/mambaforge/bin/mamba install -y fish starship direnv
$HOME/mambaforge/bin/mamba init fish
curl -L -O "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
chmod +x nvim.appimage
fish -c "alias -s v='$HOME/nvim.appimage'"

echo "exec fish" >> ~/.bashrc
