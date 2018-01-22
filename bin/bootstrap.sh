#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

print_help() {
    cat <<EOF
    $USAGE

    Install options (must pass one of these options)
      -f: Install dotfiles
      -v: Install vimfiles
      -a: Intstall dotfiles, rvm, and vim
      -z: Install 'oh-my-zsh' (not included with '-a')
      -b: Install 'bash-it'   (not included with '-a')

    Additional install options (default: Don't add these settings)
      -C: With '-z' or '-b'; change login shell to bash or zsh
      -i: Enable terminal italics

    Handling old dotfiles; pass with '-f' (default: Do nothing if they exist)
      -F: Force overwrite of all current dotfiles
      -B: Replace old dotfiles, but save them with '.bak' extension
      -A: Append new dotfiles to current dotfiles

    Usage options
      -h: Print this help and exit
      -u: Print usage and exit
EOF
    exit
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

all=false
italic=false
append=false
dotfiles=false
vim=false
zsh=false
bash=false
rvm=false
force=false
backup=false
change_shell=false

while getopts 'aiAfvzbrFBChu' opts; do
    case $opts in
        A)  append=true       ;;
        f)  dotfiles=true     ;;
        v)  vim=true          ;;
        z)  zsh=true          ;;
        b)  bash=true         ;;
        r)  rvm=true          ;;
        F)  force=true        ;;
        B)  backup=true       ;;
        C)  change_shell=true ;;
        i)  italics=true      ;;
        h)  print_help        ;;
        a)
            dotfiles=true
            vim=true
            rvm=true
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

if (( $# == 0 )); then
    echo $USAGE
    exit 1
fi

if $change_shell && !( $zsh || $bash ); then
    echo $USAGE
    echo "Must pass '-C' with '-z' or '-b'"
    exit 1
fi

if $force && !($vim || $dotfiles); then
    echo $USAGE
    echo "Must pass '-C' with '-z' or '-b'"
    exit 1
fi

if $dotfiles; then
    install_path="$( cd $( dirname $0 )/../ && pwd )"

    for file in $install_path/*; do
        sfile=${file##*/}
        if [[ -f $file ]]; then
            if $force || $backup || $append; then
                if [[ -e $HOME/.$sfile ]]; then
                    if $append; then
                        echo "$HOME/.$sfile exists. Appending..."
                        cat $HOME/.$sfile > $file.tmp
                        rm $HOME/.$sfile
                        cat $file >> $file.tmp
                        mv $file.tmp $file
                    elif $backup; then
                        echo "$HOME/.$sfile exists. Backing up..."
                        mv $HOME/.$sfile{,.bak}
                    elif $force; then
                        echo "$HOME/.$sfile exists. Removing..."
                        rm -f $HOME/.$sfile
                    fi
                fi
                ln -s $file $HOME/.$sfile
            else
                if [[ -e $HOME/.$file ]]; then
                    echo "$HOME/.$file already exists. Run with '-f' to force"
                else
                    ln -s $file $HOME/.$sfile
                fi
            fi
        fi
    done
fi

if $italics && [[ $TERM != 'xterm-256color-italic' ]]; then
    tic $HOME/.xterm-256color-italic.terminfo
fi

if $vim; then
    if [[ -d ~/.vim ]]; then
        if $force; then
            rm -rf ~/.vim
        elif $backup; then
            mv ~/.vim{,.bak}
        else
            echo "~/.vim exists. Run with '-F' to force, or '-B' to back-up"
        fi
    fi
    [[ ! -d ~/.vim ]] && clone_vim
fi

if $rvm; then
    if which rvm > /dev/null; then
        echo "rvm already installed."
    else
        echo "Installing rvm"
        "curl" -sSL https://get.rvm.io | bash -s stable
    fi
fi

if $zsh; then
    $change_shell && change_login_shell zsh

    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/custom
        git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
            ~/.oh-my-zsh/custom
    fi
fi

if $bash; then
    $change_shell && change_login_shell bash

    if [[ ! -d ~/.bash_it ]]; then
        git clone https://github.com/Bash-it/bash-it.git ~/.bash_it
    fi
fi

