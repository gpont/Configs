#!/bin/bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
cp ./.zshrc ~/.zshrc
cp ./.zshrc_oh_my_zsh ~/.zshrc_oh_my_zsh
mkdir .config
mkdir .config/nvim
cp init.vim ~/.config/nvim/init.vim
git config --global oh-my-zsh.hide-status 1
