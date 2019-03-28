
link_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if is_ignored $basename_file && ! $ALLOW_IGNORED; then
        log "$basename_file is excluded! Skipping installation."
        return 1
    fi

    if [[ -e $HOME/.$basename_file ]]; then
        if [[ -n $EXTENSION ]]; then
            log "$HOME/.$basename_file exists. " \
                "Moving to $basename_file.$EXTENSION"
            mv -f $HOME/.$basename_file \
                $INSTALL_PATH/backup/$basename_file.$EXTENSION
            if $LOCAL; then
                if ! array_includes $basename_file "${LOCAL_FILES[@]}"; then
                    log "No need to create local copy of $basename_file"
                    return
                elif [[ -f $HOME/.$basename_file.local ]]; then
                    log "Cannot create $HOME/.$basename_file.local; file exists"
                    return
                fi
                log "Linking $basename_file.$EXTENSION to" \
                    "$HOME/$basename_file.local so it can be sourced"
                ln -s $INSTALL_PATH/backup/$basename_file.$EXTENSION \
                    $HOME/.$basename_file.local
            fi
        else
            log "$HOME/.$basename_file already exists."
            echo " -- Pass '-B' to make backup, or '-L' to localize."
            return 1
        fi
    fi

    log "Linking $file => $HOME/.$basename_file"
    ln -s $file $HOME/.$basename_file
}

unlink_dotfile() {
    local backup_file
    local basename_file="${1##*/}"

    if [[ -L $HOME/.$basename_file ]]; then
        log "Removing $HOME/.$basename_file"
        rm $HOME/.$basename_file

        if $REINSTALL_OLD_DOTFILES; then
            backup_file=$(
                ls -d $INSTALL_PATH/backup/$basename_file.* | \
                    tail -n 1 2>/dev/null
            )
            if [[ -n $backup_file ]]; then
                log "Restoring .$basename_file from $backup_file (last backup)"
                mv $backup_file $HOME/.$basename_file
            else
                log "No local/backup file found for $basename_file"
            fi
        fi
    else
        log "$HOME/.$basename_file is not a symlink. Unable to remove."
    fi
}

