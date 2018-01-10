#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [options]"

print_help() {
    echo "$USAGE"
    echo '-f to force overwrite of all current dotfiles'
    echo '-h prints this help'
}

force=false

while getopts 'o' opts; do
    case $opts in
        f) force=true ;;
        h) print_help    ;;
        *) echo $USAGE   ;;
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

echo ${0%/*}
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

