#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

print_help() {
    echo "$USAGE"
    echo '-f to force overwrite of all current dotfiles'
    echo '-h prints this help'
}

force=false
vim=false
zsh=false

while getopts 'ohu' opts; do
    case $opts in
        f) force=true ;;
        v) vim=true ;;
        z) zsh=true ;;
        h) print_help ;;
        u)
            echo $USAGE
            exit 0
            ;;
        *)
            echo $USAGE
            exit 1
            ;;
    esac
done

files=(
LESS_TERMCAP
Xdefaults
Xmodmap
bashrc
cshrc
dir_colors
emacs
exedrc
hushlogin
inputrc
irbrc
pryrc
screenrc
xterm-256color-italic.terminfo
zlogin
zshrc
)

install_path="$( cd $( dirname ${0%/*} )/../ && pwd )"

for file in ${files[@]}; do
    if $force; then
        if [[ -e $HOME/.$file ]]; then
            echo "Force set to 'true' and $HOME/.$file exists. Removing..."
            rm -f $HOME/.$file
        fi
        ln -s $install_path/$file $HOME/.$file
    else
        if [[ -e $HOME/.$file ]]; then
            echo "$HOME/.$file already exists. Run with '-f' to force"
        else
            ln -s $install_path/$file $HOME/.$file
        fi
    fi
done

echo "export USER_DOTFILE_DIR=$install_path" >> ${0%/*}/../shellrc

if $zsh; then
    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/custom
        git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
            ~/.oh-my-zsh/custom
    fi
fi

if $vim; then
    [[ -d ~/.vim ]] && rm -rf ~/.vim
    git clone --recursive https://github.com/evanthegrayt/vimfiles.git ~/.vim
fi

