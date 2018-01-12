#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

print_help() {
    echo "$USAGE"
    echo '  -f: Install dotfiles'
    echo '  -v: Install vimfiles'
    echo '  -z: Change shell to zsh and install oh-my-zsh'
    echo '  -b: Change shell to zsh and Install bash-it'
    echo '  -F: Force overwrite of all current dotfiles'
    echo '  -h: Prints this help'

    exit
}

dotfiles=false
vim=false
zsh=false
bash=false
force=false
rvm=false

if [[ $# == 0 ]]; then echo "$USAGE"; exit; fi

while getopts 'fvzbrFhu' opts; do
    case $opts in
        f) dotfiles=true ;;
        v) vim=true ;;
        z) zsh=true ;;
        b) bash=true ;;
        r) rvm=true ;;
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
bash_profile
bash_logout
zlogin
zlogout
zshrc
profile
colordiffrc
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
taskrc
)

if $dotfiles; then
    install_path="$( cd $( dirname $0 )/../ && pwd )"
    echo $install_path

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

    echo "export USER_DOTFILE_DIR=$install_path" >> $( dirname $0 )/../shellrc

    if [[ $TERM != 'xterm-256color-italic' ]]; then
        tic $install_path/xterm-256color-italic.terminfo
    fi
fi

if $zsh; then
    zsh="$( grep 'zsh$' /etc/shells 2>/dev/null|head -1 )"
    if [[ -x "$zsh" ]] && grep "^$LOGNAME:" /etc/passwd >/dev/null; then
        if ! grep "^$LOGNAME:.*zsh" /etc/passwd >/dev/null; then
            echo "Changing login shell to zsh."
            chsh -s "$zsh"
        fi
        if [[ ! -d ~/.oh-my-zsh ]]; then
            git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
            rm -rf ~/.oh-my-zsh/custom
            git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
                ~/.oh-my-zsh/custom
        fi
    else
        echo "Cannot change shell to zsh; zsh executable not found."
    fi
fi

if $bash; then
    bash="$( grep 'bash$' /etc/shells 2>/dev/null|head -1 )"
    if [[ -x "$bash" ]] && grep "^$LOGNAME:" /etc/passwd >/dev/null; then
        if ! grep "^$LOGNAME:.*zsh" /etc/passwd >/dev/null; then
            echo "Changing login shell to bash."
            chsh -s "$bash"
        fi
        if [[ ! -d ~/.bash_it ]]; then
            git clone https://github.com/Bash-it/bash-it.git ~/.bash_it
        fi
    else
        echo "Cannot change shell to bash; bash executable not found."
    fi
fi

if $vim; then
    [[ -d ~/.vim ]] && rm -rf ~/.vim
    git clone --recursive https://github.com/evanthegrayt/vimfiles.git ~/.vim
fi

if $rvm; then
    echo "Installing rvm"
fi

