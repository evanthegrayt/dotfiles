#!/usr/bin/env bash
# Bootstrap script to help me install my dotfiles across different platforms

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"
readonly INSTALL_PATH="$( cd $( dirname $0 )/../ && pwd )"

print_help() {
    cat <<EOF
    $USAGE

    Install options (must pass one of these options)
      -f        | Install all dotfiles
      -s [FILE] | Install a single dotfile
      -v        | Install vimfiles
      -z        | Install 'oh-my-zsh'
      -b        | Install 'bash-it'

    Additional install options (default: Don't add these settings)
      -C        | With '-z' or '-b'; change login shell to bash or zsh
      -i        | Enable terminal italics

    Handling old dotfiles; pass with '-f' (default: Do nothing if they exist)
      -F        | Force overwrite of all current dotfiles
      -B        | Replace old dotfiles, but save them with '.bak' extension
      -A        | Append new dotfiles to current dotfiles. Note that this will
                | not link the file, but wil add to the file in your home dir.

    Usage options
      -h: Print this help and exit
      -u: Print usage and exit
EOF
    exit
}

link_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if [[ -f $file ]]; then
        if $FORCE || $BACKUP || $APPEND; then
            if [[ -e $HOME/.$basename_file ]]; then
                if $APPEND; then
                    echo "$HOME/.$basename_file exists. Appending..."
                    cat $file >> $HOME/.$basename_file
                elif $BACKUP; then
                    echo "$HOME/.$basename_file exists. Backing up..."
                    mv $HOME/.$basename_file{,.bak}
                elif $FORCE; then
                    echo "$HOME/.$basename_file exists. Removing..."
                    rm -f $HOME/.$basename_file
                fi
            fi
            ln -s $file $HOME/.$basename_file
        else
            if [[ -e $HOME/.$basename_file ]]; then
                echo "$HOME/.$basename_file already exists. Pass '-F' to force"
            else
                ln -s $file $HOME/.$basename_file
            fi
        fi
    fi
}

change_login_shell() {
    local passed_shell=$1
    local shell="$( grep "$passed_shell$" /etc/shells 2>/dev/null | tail -n 1 )"

    if [[ -x "$shell" ]] && grep "^$LOGNAME:" /etc/passwd >/dev/null; then
        if ! grep "^$LOGNAME:.*$shell" /etc/passwd >/dev/null; then
            echo "Changing login shell to $shell."
            chsh -s "$shell"
        fi
    else
        echo "Cannot change shell to $shell; $shell executable not found."
    fi
}

clone_vim() {
    git clone --recursive https://github.com/evanthegrayt/vimfiles.git ~/.vim
}

ITALICS=false
APPEND=false
INSTALL_DOTFILES=false
INSTALL_VIM=false
INSTALL_ZSH=false
INSTALL_BASH=false
INSTALL_RVM=false
FORCE=false
BACKUP=false
CHANGE_SHELL=false

while getopts 'aiAfvzbrFBChus:' opts; do
    case $opts in
        A)  APPEND=true           ;;
        f)  INSTALL_DOTFILES=true ;;
        v)  INSTALL_VIM=true      ;;
        z)  INSTALL_ZSH=true      ;;
        b)  INSTALL_BASH=true     ;;
        r)  INSTALL_RVM=true      ;;
        F)  FORCE=true            ;;
        B)  BACKUP=true           ;;
        C)  CHANGE_SHELL=true     ;;
        i)  ITALICS=true          ;;
        h)  print_help            ;;
        s)
            single_file=$OPTARG
            [[ $single_file =~ ^\. ]] && single_file=${single_file#*.}
            ;;
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

readonly FORCE APPEND INSTALL_DOTFILES INSTALL_VIM INSTALL_ZSH INSTALL_BASH
readonly INSTALL_RVM BACKUP ITALICS CHANGE_SHELL

if (( $# == 0 )); then
    echo $USAGE
    exit 1
fi

if $INSTALL_DOTFILES && [[ -n $single_file ]]; then
    echo $USAGE
    echo "Cannot pass '-f' with '-s FILE'"
    exit 1
fi

if $CHANGE_SHELL && !( $INSTALL_ZSH || $INSTALL_BASH ); then
    echo $USAGE
    echo "Must pass '-C' with '-z' or '-b'"
    exit 1
fi

if $FORCE && !( $INSTALL_VIM || $INSTALL_DOTFILES ); then
    echo $USAGE
    echo "Must pass '-C' with '-z' or '-b'"
    exit 1
fi

if [[ -n $single_file ]]; then
    link_dotfile "$INSTALL_PATH/$single_file"
elif $INSTALL_DOTFILES; then
    for file in $INSTALL_PATH/*; do
        link_dotfile "$file"
    done
fi

if $ITALICS && [[ $TERM != 'xterm-256color-italic' ]]; then
    tic $HOME/.xterm-256color-italic.terminfo
fi

if $INSTALL_VIM; then
    if [[ -d ~/.vim ]]; then
        if $FORCE; then
            rm -rf ~/.vim
        elif $BACKUP; then
            mv ~/.vim{,.bak}
        else
            echo "~/.vim exists. Run with '-F' to force, or '-B' to back-up"
        fi
    fi
    [[ ! -d ~/.vim ]] && clone_vim
fi

if $INSTALL_RVM; then
    if which rvm > /dev/null; then
        echo "rvm already installed."
    else
        echo "Installing rvm"
        "curl" -sSL https://get.rvm.io | bash -s stable
    fi
fi

if $INSTALL_ZSH; then
    $CHANGE_SHELL && change_login_shell zsh

    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/custom
        git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
            ~/.oh-my-zsh/custom
    fi
fi

if $INSTALL_BASH; then
    $CHANGE_SHELL && change_login_shell bash

    if [[ ! -d ~/.bash_it ]]; then
        git clone https://github.com/Bash-it/bash-it.git ~/.bash_it
    fi
fi

