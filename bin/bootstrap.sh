#!/usr/bin/env bash

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

print_help() {
    cat <<EOF
    $USAGE
      -f: Install dotfiles
      -v: Install vimfiles
      -a: Intstall everything. Must still pass '-z' or '-b' for shell
      -z: Change shell to zsh and install oh-my-zsh
      -b: Change shell to bash and Install bash-it
      -F: Force overwrite of all current dotfiles
      -B: Same as '-f', but save with '.bak' extensions
      -h: Print this help and exit
      -u: Print usage and exit
EOF
    exit
}

change_login_shell() {
    local passed_shell=$1

    shell="$( grep "$passed_shell$" /etc/shells 2>/dev/null | tail -n 1 )"
    if [[ -x "$shell" ]] && grep "^$LOGNAME:" /etc/passwd >/dev/null; then
        if ! grep "^$LOGNAME:.*$shell" /etc/passwd >/dev/null; then
            echo "Changing login shell to $shell."
            chsh -s "$shell"
        fi
    else
        echo "Cannot change shell to $shell; $shell executable not found."
    fi
}

all=false
dotfiles=false
vim=false
zsh=false
bash=false
rvm=false
force=false
backup=false
change_shell=false

if (( $# == 0 )); then echo "$USAGE"; exit 1; fi

while getopts 'rafvzbrFBhu' opts; do
    case $opts in
        a)  all=true      ;;
        f)  dotfiles=true ;;
        v)  vim=true      ;;
        z)  zsh=true      ;;
        b)  bash=true     ;;
        r)  rvm=true      ;;
        F)  force=true    ;;
        B)  backup=true   ;;
        h)  print_help    ;;
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

if $dotfiles || $all; then
    install_path="$( cd $( dirname $0 )/../ && pwd )"

    for file in $install_path/*; do
        sfile=${file##*/}
        if [[ -f $file ]]; then
            if $force || $backup; then
                if [[ -e $HOME/.$sfile ]]; then
                    if $backup; then
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

    if [[ $TERM != 'xterm-256color-italic' ]]; then
        tic $HOME/.xterm-256color-italic.terminfo
    fi
fi


if $vim || $all; then
    if [[ -d ~/.vim ]]; then
        if $force; then
            rm -rf ~/.vim
            git clone --recursive https://github.com/evanthegrayt/vimfiles.git \
                ~/.vim
        elif $backup; then
            mv ~/.vim{,.bak}
            git clone --recursive https://github.com/evanthegrayt/vimfiles.git \
                ~/.vim
        else
            echo "~/.vim exists. Run with '-F' to force, or '-B' to back-up"
        fi
    fi
fi

if $rvm || $all; then
    if which rvm > /dev/null; then
        echo "rvm already installed."
    else
        echo "Installing rvm"
        "curl" -sSL https://get.rvm.io | bash -s stable
    fi
fi

if $zsh; then
    if $change_shell; then
        change_login_shell zsh
    fi

    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/custom
        git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
            ~/.oh-my-zsh/custom
    fi
fi

if $bash; then
    if $change_shell; then
        change_login_shell bash
    fi

    if [[ ! -d ~/.bash_it ]]; then
        git clone https://github.com/Bash-it/bash-it.git ~/.bash_it
    fi
fi

