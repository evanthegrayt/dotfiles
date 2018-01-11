#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

print_help() {
    echo "$USAGE"
    echo '  -f: Install dotfiles'
    echo '  -v: Install vimfiles'
    echo '  -z: Install oh-my-zsh'
    echo '  -F: Force overwrite of all current dotfiles'
    echo '  -h: Prints this help'

    exit
}

force=false
vim=false
zsh=false

if [[ $# == 0 ]]; then echo $USAGE; exit; fi

while getopts 'fvzhu' opts; do
    case $opts in
        f) dotfiles=true ;;
        v) vim=true ;;
        z) zsh=true ;;
        F) force=true ;;
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

if $dotfiles; then
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

    echo "export USER_DOTFILE_DIR=$install_path" >> $(dirname ${0%/*})/../shellrc
fi

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

