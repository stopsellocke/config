# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

if [ -f $HOME/.zsh/zsh-include ]
then
    . $HOME/.zsh/zsh-include
fi

