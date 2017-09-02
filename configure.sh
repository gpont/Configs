#!/bin/bash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
wget -O ~/.zshrc https://gitlab.com/gpont/configs/raw/master/.zshrc
wget -O ~/.zshrc_oh_my_zsh https://gitlab.com/gpont/configs/raw/master/.zshrc_oh_my_zsh
mkdir .config
mkdir .config/nvim
wget -O ~/.config/nvim/init.vim https://gitlab.com/gpont/configs/raw/master/init.vim
git config --global oh-my-zsh.hide-status 1
