#!/bin/bash

function linkFile {
  echo -n $1
  if [ -e ~/$1 ]
  then
    if [ ! -L ~/$1 ]
    then
      if [ ! -d ~/backup ]
      then
        mkdir -p ~/backup
      fi
      cp -ap ~/$1 ~/backup
    fi
    rm -rf ~/$1
  fi
  ln -s ~/config/$1 ~/$1
  echo " [OK]\n"
}

linkFile ".bashrc"
linkFile ".zsh"
linkFile ".zshrc"

linkFile ".vim"
# vim vundle
if [ ! -d ~/.vim/bundle/Vundle.vim ]
then
  $(git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim)
fi

linkFile ".vimrc"
if [ -x "$(command -v vim)" ];
then
  vim +PluginInstall +qall
fi

linkFile ".gitconfig"
linkFile ".tmux.conf"
if [ ! -d ~/.tmux/plugins/tpm ]
then
  $(git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm)
  $(~/.tmux/plugins/tpm/bin/install_plugins)
fi

if [ ! -d ~/.ssh ]
then
  mkdir -p ~/.ssh
fi
linkFile ".ssh/config"
