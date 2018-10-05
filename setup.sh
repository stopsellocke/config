#!/bin/bash

function linkFile {
  echo -n $1
  if [ -e ~/$1 ]
  then
    if [ ! -L ~/$1 ]
    then
      if [ ! -d ~/backup ]
      then
        mkdir -p "~/backup"
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
# oh-my-zsh
if [ ! -d ~/.zsh/.oh-my-zsh ]
then
  $(git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.zsh/.oh-my-zsh)
fi

# powerlevel9k
if [ ! -d ~/.zsh/.oh-my-zsh/custom/themes/powerlevel9k ]
then
  $(git clone https://github.com/bhilburn/powerlevel9k.git ~/.zsh/.oh-my-zsh/custom/themes/powerlevel9k)
fi

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

if [ ! -d ~/.ssh ]
then
  mkdir -p ~/.ssh
fi
linkFile ".ssh/config"
