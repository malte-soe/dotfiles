cd "$HOME/.config"
git init
git remote add origin https://github.com/malte-soe/dotfiles.git
git pull origin master

curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-$(uname)-$(uname -m).sh"
bash Mambaforge-$(uname)-$(uname -m).sh -b
source ~/.bashrc

mamba install fish
mamba install starship
curl -L -O "https://github.com/neovim/neovim/releases/download/stable/nvim.appimage"
chmod +x nvim.appimage

echo "exec fish" >> ~/.bashrc
