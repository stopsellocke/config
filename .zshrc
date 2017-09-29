## The following lines were added by compinstall
#zstyle :compinstall filename '/home/Hans/.zshrc'
#
#autoload -Uz compinit
#compinit
#
#autoload colors; colors
## End of lines added by compinstall
#
#alias ls"ls --color=auto"
alias l="ls -al"

# My .zshrc file
#
# Written by Matthew Blissett.
#
# Latest version available from http://matt.blissett.me.uk/linux/zsh/zshrc
#
# Some functions taken from various web sites/mailing lists, others written
# myself.
#
# Last updated 2015-01-23
#
# Released into the public domain.
#

# Skip all this for non-interactive shells
[[ -z "$PS1" ]] && return

# Set prompt (white and purple, nothing too fancy)
#PS1=$'%{\e[0;37m%}%B%*%b %{\e[0;35m%}%m:%{\e[0;37m%}%~ %(!.#.>) %{\e[00m%}'
# Fancier prompt
# Exit status indicator in red (if not 0)
# Job count in yellow (if not 0)
# Date in white, host in magenta, directory in default, prompt character
# Example:
#     1J 23:06:26 ig:~ >
PS1=$'%F{def}%(?..%B%K{red}[%?]%K{def}%b )%(1j.%b%K{yel}%F{bla}%jJ%F{def}%K{def} .)%F{white}%B%*%b %F{m}%m:%F{white}%~ %(!.#.>) %F{def}'
#PS1='\[\033[01;32m\][\u@\h] \[\033[01;34m\]`pwd`\[\033[00m\]$(__git_ps1)\[\033[01;34m\] $(jobscount)\$>\[\033[00m\] '

# Set less options
if [[ -x $(which less 2> /dev/null) ]]
then
    export PAGER="less"
    export LESS="--ignore-case --LONG-PROMPT --QUIET --chop-long-lines -Sm --RAW-CONTROL-CHARS --quit-if-one-screen --no-init"
    export LESSHISTFILE='-'
    if [[ -x $(which lesspipe 2> /dev/null) ]]
    then
	LESSOPEN="| lesspipe %s"
	export LESSOPEN
    fi
fi

# Set default editor
if [[ -x $(which vim 2> /dev/null) ]]
then
    export EDITOR="vim"
    export USE_EDITOR=$EDITOR
    export VISUAL=$EDITOR
fi

# Zsh settings for history
export HISTIGNORE="&:ls:[bf]g:exit:reset:clear:cd:cd ..:cd..:zh"
export HISTSIZE=25000
export HISTFILE=~/.zsh_history
export SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Say how long a command took, if it took more than 30 seconds
export REPORTTIME=30

# Colour output on Mac OS
export CLICOLOR=1

# Zsh spelling correction options
#setopt CORRECT
#setopt DVORAK

# Prompts for confirmation after 'rm *' etc
# Helps avoid mistakes like 'rm * o' when 'rm *.o' was intended
setopt RM_STAR_WAIT

# Background processes aren't killed on exit of shell
setopt AUTO_CONTINUE

# Don’t write over existing files with >, use >! instead
setopt NOCLOBBER

# Don’t nice background processes
setopt NO_BG_NICE

# Watch other user login/out
watch=notme
export LOGCHECK=60

# Enable color support of ls
if [[ "$TERM" != "dumb" ]]; then
    if [[ -x `which dircolors 2> /dev/null` ]]; then
	eval `dircolors -b`
	alias 'ls=ls --color=auto'
    fi
fi

# Why is the date American even when the locale is en_GB?  Fix with this
export TIME_STYLE="long-iso"

# Commas in ls, du, df output
export BLOCK_SIZE="'1"

# Play safe!
alias 'rm=rm -i'
alias 'mv=mv -i'
alias 'cp=cp -i'

# Remove a known host and its IP from the cache
ssh-knownhosts-remove() {
    ssh-keygen -R $1
    ssh-keygen -R $(dig $1 +short)
}

# Automatically background processes (no output to terminal etc)
z () {
    grey='\e[1;30m'
    norm='\e[m'
    outfile=$(mktemp --tmpdir ${1//\//}.XXX)
    echo "$grey$* &> $outfile$norm"
    $* &>! $outfile &!
}


# Quick find
f() {
    echo "find . -iname \"*$1*\""
    find . -iname "*$1*"
}


# Change between English and Danish
english() {
    export LANG=en_GB.UTF-8
    export LANGUAGE=en_GB:en
}
danish() {
    export LANG=da_DK.UTF-8
    export LANGUAGE=da_DK:da
}

# Change terminal title
title() {
    echo -ne "\033]30;$*\007"
}


# When directory is changed set xterm title to host:dir
chpwd() {
    [[ -t 1 ]] || return
    case $TERM in
	sun-cmd) print -Pn "\e]l%~\e\\";;
        *xterm*|rxvt|(dt|k|E)term) print -Pn "\e]2;%m:%~\a";;
    esac
}

# For changing the umask automatically
chpwd () {
    case $PWD in
        $HOME/[Dd]ocuments*)
            if [[ $(umask) -ne 077 ]]; then
                umask 0077
                echo -e "\033[01;32mumask: private \033[m"
            fi;;
        /web*|$HOME/[Ww]eb*)
            if [[ $(umask) -ne 072 ]]; then
                umask 0072
                echo -e "\033[01;33mumask: other readable \033[m"
            fi;;
        /nothing)
            if [[ $(umask) -ne 002 ]]; then
                umask 0002
                echo -e "\033[01;35mumask: group writable \033[m"
            fi;;
        *)
            if [[ $(umask) -ne 022 ]]; then
                umask 0022
                echo -e "\033[01;31mumask: world readable \033[m"
            fi;;
    esac
}
cd . &> /dev/null


# Calculate the difference in whole days between two dates, ignoring timezone changes
datediff () {
    echo $(( ($(date -u -d $1 +%s) - $(date -u -d $2 +%s)) / 86400))
}


# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _match
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' glob 0
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list '+m:{a-z}={A-Z} r:|[._-]=** r:|=**' '' '' '+m:{a-z}={A-Z} r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1 numeric
zstyle ':completion:*' substitute 0
zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Completers for my own scripts
zstyle ':completion:*:*:(album-cover|copy-geotag):*' file-patterns '*.(#i)(jp*g|png|tif*)'

zstyle ':completion:*:*:photo-sort:*' file-patterns '*(/)'
zstyle ':completion:*:*:photo-sort:*' file-sort time

compdef untilquit=pkill

# Don't complete backup files as commands.
zstyle ':completion:*:complete:-command-::*' ignored-patterns '*\~'

# Username completion.
# Delete old definitions
zstyle -d users
# For SSH and Rsync, use remote users set in SSH configuration, plus root
#zstyle ':completion:*:*:(ssh|rsync):*' users root $(awk '$1 == "User" { print $2 }' ~/.ssh/config | sort -u)
# For everything else, use non-system users from /etc/passwd, plus root
zstyle ':completion:*:*:*:*' users root $(awk -F: '$3 > 1000 && $3 < 65000 { print $1 }' /etc/passwd)

# Hostname completion
#zstyle ':completion:*' hosts $( grep -h '\.' $HOME/.hosts* )

# URL completion. Use URLs from history.
zstyle -e ':completion:*:*:urls' urls 'reply=( ${${(f)"$(egrep --only-matching \(ftp\|https\?\)://\[A-Za-z0-9\].\* $HISTFILE)"}%%[# ]*} )'

# Quote stuff that looks like URLs automatically.
autoload -U url-quote-magic
zstyle ':urlglobber' url-other-schema ftp git gopher http https magnet
zstyle ':url-quote-magic:*' url-metas '*?[]^(|)~#='
zle -N self-insert url-quote-magic

# File/directory completion, for cd command
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#lost+found' '(*/)#CVS'
#  and for all commands taking file arguments
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'

# Prevent offering a file (process, etc) that's already in the command line.
zstyle ':completion:*:(rm|cp|kill|diff|scp):*' ignore-line yes
# (Use Alt-Comma to do something like "mv abcd.efg abcd.efg.old")

# Completion selection by menu for kill
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'

# Filename suffixes to ignore during completion (except after rm command)
# This doesn't seem to work
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(^rm):*' ignored-patterns '*?.o' '*?.c~' '*?.old' '*?.pro' '*~'
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
#zstyle ':completion:*:(all-|)files' file-patterns '(*~|\\#*\\#):backup-files' 'core(|.*):core\ files' '*:all-files'

zstyle ':completion:*:*:rmdir:*' file-sort time

#[[ -d /web/matt.blissett.me.uk]] && zstyle ':completion:*' local matt.blissett.me.uk /web/matt.blissett.me.uk

# CD to never select parent directory
zstyle ':completion:*:cd:*' ignore-parents parent pwd

## Use cache
# Some functions, like _apt and _dpkg, are very slow. You can use a cache in
# order to proxy the list of results (like the list of available debian
# packages)
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

autoload zsh/sched

# Copys word from earlier in the current command line
# or previous line if it was chosen with ^[. etc
autoload copy-earlier-word
zle -N copy-earlier-word
bindkey '^[,' copy-earlier-word

# Cycle between positions for ambigous completions
autoload cycle-completion-positions
zle -N cycle-completion-positions
bindkey '^[z' cycle-completion-positions

# Increment integer argument
autoload incarg
zle -N incarg
bindkey '^X+' incarg

# Write globbed files into command line
autoload insert-files
zle -N insert-files
bindkey '^Xf' insert-files

# Play tetris
#autoload -U tetris
#zle -N tetris
#bindkey '^X^T' tetris

# xargs but zargs
autoload -U zargs

# Calculator
autoload zcalc

# Line editor
autoload zed

# Renaming with globbing
autoload zmv

# Add Git functions 
if [[ -d ~/.matt-config/zsh-git/functions ]]; then
    fpath=($fpath ~/.matt-config/zsh-git/functions)
    typeset -U fpath
    setopt promptsubst
    autoload -U promptinit
    promptinit
    prompt wunjo
fi

# Git completion, retrieved from https://git.kernel.org/cgit/git/git.git/tree/contrib/completion/git-completion.zsh
if [[ -f ~/.matt-config/git-completion.zsh ]]; then
    fpath=(~/.matt-config/git-completion.zsh $fpath)
fi

# PRLL, for parallel shell processing
if [[ -e ~/.matt-config/prll/prll.sh ]]; then
    source ~/.matt-config/prll/prll.sh
fi

# Various reminders of things I forget...
# (Mostly useful features that I forget to use)
# vared
# =ls turns to /bin/ls
# =(ls) turns to filename (which contains output of ls)
# <(ls) turns to named pipe
# ^X* expand word
# ^[^_ copy prev word
# ^[A accept and hold
# echo $name:r not-extension
# echo $name:e extension
# echo $xx:l lowercase
# echo $name:s/foo/bar/

# Quote current line: M-'
# Quote region: M-"

# Up-case-word: M-u
# Down-case-word: M-l
# Capitilise word: M-c

# kill-region

# expand word: ^X*
# accept-and-hold: M-a
# accept-line-and-down-history: ^O
# execute-named-cmd: M-x
# push-line: ^Q
# run-help: M-h
# spelling correction: M-s

# echo ${^~path}/*mous*

# Add host/domain specific zshrc
domainname() {
    setopt extended_glob local_options
    hostname -d 2> /dev/null || echo ${$(hostname -f)#[a-z0-9-]##\.}
}

if [ -f $HOME/.zshrc-$HOST ]
then
    . $HOME/.zshrc-$HOST
fi

if [ -f $HOME/.zshrc-$(hostname -f) ]
then
    . $HOME/.zshrc-$(hostname -f)
fi

if [ -f $HOME/.zshrc-$(domainname) ]
then
    . $HOME/.zshrc-$(domainname)
fi

# Get round annoyance in Gentoo
# (No idea if this is needed any more)
