
abort() {
    local msg="$1"

    printf "$msg\n" >&2
    exit 1
}

contains_element() {
    local match="$1"
    local element
    shift

    for element; do
        if [[ "$element" == "$match" ]]; then
            return 0
        fi
    done

    return 1
}

print_help() {
    echo $USAGE
    cat $INSTALL_PATH/lib/help_menu.txt
    exit
}

is_excluded() {
    local file="$1"

    grep -q "^\s*-\s*$file\s*$" $INSTALL_PATH/lib/ignore.yml
}

link_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if is_excluded $basename_file && ! $ALLOW_IGNORED; then
        echo "$basename_file is excluded!"
        return 1
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
                    mv $HOME/.$basename_file{,.$EXTENSION}
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
    local basename_file="${1##*/}"

    echo $basename_file
    if [[ -L $HOME/.$basename_file ]]; then
        rm $HOME/.$basename_file

        if $REINSTALL_OLD_DOTFILES; then
            if [[ -n $EXTENSION && -f $HOME/.$basename_file.$EXTENSION ]]; then
                mv $HOME/.$basename_file{.$EXTENSION,}
            elif [[ -f $HOME/.$basename_file.local ]]; then
                mv $HOME/.$basename_file{.local,}
            elif [[ -f $HOME/.$basename_file.bak ]]; then
                mv $HOME/.$basename_file{.bak,}
            fi
        fi
    fi
}

clone_vim() {
    git clone --recursive \
        https://github.com/evanthegrayt/vimfiles.git $HOME/.vim
}

