#!/usr/bin/env bash
# Bootstrap script to help me install my dotfiles across different platforms
# TODO When {,re}moving files, make sure they were actually {,re}moved

readonly USAGE="USAGE: ${0##*/} [OPTIONS]"
readonly INSTALL_PATH="$( cd $( dirname $0 )/../ && pwd )"
readonly EXCLUDED_FILES=(README.md)

abort() {
    printf "$1\n" >&2
    exit 1
}

contains_element() {
  local match="$1"
  local element
  shift

  for element; do [[ "$element" == "$match" ]] && echo 'true'; done
  echo 'false'
}

print_help() {
    cat <<EOF
    $USAGE

    Install options (must pass one of these options)
      -f         | Install all dotfiles
      -s [FILE]  | Install a single dotfile
      -v         | Install vimfiles
      -z         | Install 'oh-my-zsh'
      -b         | Install 'bash-it'

    Additional install options (default: Don't add these settings)
      -C [SHELL] | Change login shell to [SHELL]
      -i         | Enable terminal italics

    Handling old dotfiles; pass with '-f' (default: Do nothing if they exist)
      -F         | Force overwrite of all current dotfiles
      -B         | Replace old dotfiles, but save them with '.bak' extension
      -L         | If file already exists, move it to [FILE].local. This is
                 + different from '-B', because my dotfiles will source a file
                 + of the same name if it's in the home directory with the
                 + '.local' extension. This allows for additional settings to be
                 + applied on different systems.
      -U         | Unlink files

    Usage options
      -h         | Print this help and exit
      -u         | Print usage and exit
EOF
    exit
}

link_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if $( contains_element $basename_file "${EXCLUDED_FILES[@]}" ); then
        echo "$basename_file is excluded!"
        return
    fi

    if [[ -f $file ]]; then
        if $FORCE || [[ -n $EXTENSION ]]; then
            if [[ -e $HOME/.$basename_file ]]; then
                if $FORCE; then
                    echo "$HOME/.$basename_file exists. Removing..."
                    rm -f $HOME/.$basename_file
                elif [[ -n $EXTENSION ]]; then
                    printf "$HOME/.$basename_file exists. "
                    echo "Moving to $basename_file.$EXTENSION"
                    mv ~/.$basename_file{,.$EXTENSION}
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

unlink_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if [[ -L $HOME/.$basename_file ]]; then
        rm $HOME/.$basename_file
    fi
}

clone_vim() {
    git clone --recursive https://github.com/evanthegrayt/vimfiles.git ~/.vim
}

UNINSTALL=false
ITALICS=false
INSTALL_DOTFILES=false
INSTALL_VIM=false
INSTALL_ZSH=false
INSTALL_BASH=false
INSTALL_RVM=false
FORCE=false
BACKUP=false

while getopts 'UaiLfvzbrFBChus:' opts; do
    case $opts in
        U)  UNINSTALL=true        ;;
        L)  EXTENSION='local'     ;;
        f)  INSTALL_DOTFILES=true ;;
        v)  INSTALL_VIM=true      ;;
        z)  INSTALL_ZSH=true      ;;
        b)  INSTALL_BASH=true     ;;
        r)  INSTALL_RVM=true      ;;
        F)  FORCE=true            ;;
        B)  EXTENSION='bak'       ;;
        i)  ITALICS=true          ;;
        h)  print_help            ;;
        C)
            CHANGE_SHELL=$OPTARG
            case $CHANGE_SHELL in
                z|zsh)  CHANGE_SHELL='zsh'  ;;
                b|bash) CHANGE_SHELL='bash' ;;
                c|csh)  CHANGE_SHELL='csh'  ;;
                *) abort "Must pass '-C [bash|zsh|csh]'"
            esac
            ;;
        s)
            single_file=$OPTARG
            [[ $single_file =~ ^\. ]] && single_file=${single_file#*.}
            ;;
        u)
            echo $USAGE
            exit 0
            ;;
        *)
            abort $USAGE
            ;;
    esac
done

readonly FORCE EXTENSION INSTALL_DOTFILES INSTALL_VIM INSTALL_ZSH
readonly INSTALL_RVM BACKUP ITALICS CHANGE_SHELL INSTALL_BASH UNINSTALL

if (( $# == 0 )); then
    abort $USAGE
fi

if $UNINSTALL; then
    for file in $INSTALL_PATH/*; do
        unlink_dotfile "$file"
    done
fi

if [[ -n $CHANGE_SHELL ]]; then
    shell="$( grep "$CHANGE_SHELL$" /etc/shells 2>/dev/null | tail -n 1 )"

    if [[ -x "$shell" ]] && grep "^$LOGNAME:" /etc/passwd >/dev/null; then
        if ! grep "^$LOGNAME:.*$shell" /etc/passwd >/dev/null; then
            echo "Changing login shell to $shell."
            chsh -s "$shell"
        fi
    else
        echo "Cannot change shell to $shell; $shell executable not found."
    fi
fi

if $INSTALL_DOTFILES && [[ -n $single_file ]]; then
    abort "$USAGE\nCannot pass '-f' with '-s FILE'"
fi

if $FORCE && !( $INSTALL_VIM || $INSTALL_DOTFILES ); then
    abort "$USAGE\nMust pass '-C' with '-z' or '-b'"
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
        elif [[ -n $EXTENSION ]]; then
            mv ~/.vim{,.$EXTENSION}
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
    if [[ ! -d ~/.oh-my-zsh ]]; then
        git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
        rm -rf ~/.oh-my-zsh/custom
        git clone https://github.com/evanthegrayt/oh-my-zsh-custom.git \
            ~/.oh-my-zsh/custom
    fi
fi

if $INSTALL_BASH; then
    if [[ ! -d ~/.bash_it ]]; then
        git clone https://github.com/Bash-it/bash-it.git ~/.bash_it
    fi
fi

