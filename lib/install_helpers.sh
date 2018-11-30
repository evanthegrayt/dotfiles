
abort() {
    local msg=("$@")

    printf "%s\n" "${msg[@]}" >&2
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
    echo "$( < $INSTALL_PATH/lib/help_menu.txt )"

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
        log "$basename_file is excluded! Skipping installation."
        return 1
    fi

    if [[ -e $HOME/.$basename_file ]]; then
        if $FORCE; then
            log "$HOME/.$basename_file exists. Moving to backup folder..."
            mv -f $HOME/.$basename_file $INSTALL_PATH/backup/$basename_file
        elif [[ -n $EXTENSION ]]; then
            log "$HOME/.$basename_file exists. " \
                "Moving to $basename_file.$EXTENSION"
            mv -f $HOME/.$basename_file \
                $INSTALL_PATH/backup/$basename_file.$EXTENSION
            if [[ $EXTENSION == 'local' ]]; then
                log "Linking $basename_file.$EXTENSION to $HOME"\
                    "so it can be sourced"
                ln -s $INSTALL_PATH/backup/$basename_file.$EXTENSION \
                    $HOME/.$basename_file.$EXTENSION
            fi
        else
            log "$HOME/.$basename_file already exists. Pass '-F' to force"
            return 1
        fi
    fi

    log "Linking $file => $HOME/.$basename_file"
    ln -s $file $HOME/.$basename_file
}

unlink_dotfile() {
    local basename_file="${1##*/}"

    if [[ -L $HOME/.$basename_file ]]; then
        log "Removing $HOME/.$basename_file"
        rm $HOME/.$basename_file

        if $REINSTALL_OLD_DOTFILES; then
            if [[ -f $INSTALL_PATH/backup/$basename_file.local ]]; then
                if [[ -L $HOME/.$basename_file.local ]]; then
                    rm $HOME/.$basename_file.local
                fi
                log "Restoring .$basename_file from .$basename_file.local"
                mv $INSTALL_PATH/backup/$basename_file.local \
                    $HOME/.$basename_file
            elif [[ -f $INSTALL_PATH/backup/$basename_file.bak ]]; then
                log "Restoring .$basename_file from .$basename_file.bak"
                mv $INSTALL_PATH/backup/$basename_file.bak \
                    $HOME/.$basename_file
            else
                log "No local/backup file found for $basename_file"
            fi
        fi
    else
        log "$HOME/.$basename_file is not a symlink. Unable to remove."
    fi
}

clone_vim() {
    log "Cloning vim from $VIM_REPO"
    git clone --recursive $VIM_REPO $HOME/.vim
}

clone_shell_framework() {
    local directory="$1"
    local url="$2"
    local custom_url="$3"

    if [[ -d $HOME/$directory ]]; then
        log "$HOME/$directory already exists."
        return
    fi

    log "Installing $HOME/$directory from $url"
    git clone $url $HOME/$directory
    if [[ -n $custom_url ]]; then
        rm -rf $HOME/$directory/custom
        log "Installing $HOME/$directory/custom from $custom_url"
        git clone $custom_url $HOME/$directory/custom
    fi
}

log() {
    local msg="$@"
    local prefix="[$( date "+%Y-%m-%d %H:%M:%S" )]:"

    echo "$prefix $msg" | tee -a $INSTALL_PATH/log/dotfiles.log
}

