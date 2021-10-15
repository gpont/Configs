#!/bin/bash

cd "$HOME"

system_type=$(uname -s)

# Zsh and Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ./.zshrc ~/.zshrc
mkdir ~/.zshrc
cp ./.zsh/oh_my_zsh.zshrc ~/.zsh/oh_my_zsh.zshrc
mkdir ~/.config
mkdir ~/.config/nvim
cp init.vim ~/.config/nvim/init.vim
cp .ideavim ~/.ideavim
git config --global oh-my-zsh.hide-status 1
git config --global push.default current

git clone https://github.com/jimeh/zsh-peco-history.git $ZSH_CUSTOM/plugins/zsh-peco-history

# MacOS only

if [ "$system_type" = "Darwin" ]; then
    # Brew
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew update && brew upgrade
    brew install nvim git gpg wget pip bat
fi

# Fix deoplete plugin in neovim
pip3 install neovim
