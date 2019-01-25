
abort() {
    local msg=("$@")

    printf "%s\n" "${msg[@]}" >&2
    exit 1
}

array_includes() {
    local match="$1"
    local element
    shift

    for element; do [[ "$element" == "$match" ]] && return 0; done

    return 1
}

print_help() {
    echo $USAGE
    echo "$( < $INSTALL_PATH/lib/help_menu.txt )"

    exit
}

is_in_ignore_yml_file() {
    local file="$1"

    grep -q "^\s*-\s*$file\s*$" $INSTALL_PATH/lib/ignore.yml
}

link_dotfile() {
    local file="$1"
    local basename_file="${file##*/}"

    if is_in_ignore_yml_file $basename_file && ! $ALLOW_IGNORED; then
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
            log "$HOME/.$basename_file already exists. Pass '-B' to make backup"
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

clone_vim() {
    log "Cloning vim from $VIM_REPO"
    git clone --recursive $VIM_REPO $HOME/.vim
}

clone_shell_framework() {
    local directory="$1"
    local url="$2"
    local custom_url="$3"

    if [[ -d $directory ]]; then
        log "$directory already exists."
        return
    fi

    log "Installing $directory from $url"
    git clone $url $directory

    if [[ -n $custom_url ]]; then
        rm -rf $directory/custom
        log "Installing $directory/custom from $custom_url"
        git clone --recursive $custom_url $directory/custom
    fi
}

install_mac_work_stuff() {
    local inst=()
    local to_check=()
    local title="Please manually install:"

    install_program '/Library/Developer/CommandLineTools' \
        'xcode-select --install'
    install_program rvm        "'curl' -sSL https://get.rvm.io | bash -s stable"
    install_program brew        "/usr/bin/env ruby -e '$( curl -fsSL $BREW )'"
    install_program git-lfs     'brew install git-lfs'
    install_program virtualbox  'brew cask install virtualbox'
    install_program vagrant     'brew cask install vagrant'
    install_program tunnelblick 'brew cask install tunnelblick'

    (( ${#to_check[@]} == 0 )) && return

    for check in ${to_check[@]}; do
        if [[ ! -d /Applications/$check.app ]]; then
            log "$check needs to be manually installed."
            inst+=($check)
        fi
    done
    if (( ${#inst[@]} != 0 )); then
        osascript -e "display notification \"${inst[@]}\" with title \"$title\""
    fi
}

install_ruby_gems() {
    local gem

    for gem in ${GEMS[@]}; do
        gem install $gem
    done
}

install_program() {
    local exe="$1"
    local install_cmd="$2"

    if which $exe > /dev/null || [[ -d $exe ]]; then
        log "Skipping ${exe##*/} installation; already installed."
        return
    fi

    log "Installing ${exe##*/}"
    $install_cmd
}

git_directory_is_clean() {
    # taken from https://www.spinics.net/lists/git/msg142043.html
    # Update the index
    local err=0

    git update-index -q --ignore-submodules --refresh

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --; then
        echo >&2 "You have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --; then
        echo >&2 "Your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if (( $err == 1 )); then
        echo >&2 "Please commit or stash them."
    fi

    return $err
}

log() {
    local msg="$@"
    local timestamp="$( date "+%Y-%m-%d %H:%M:%S" )"
    local logfile="$INSTALL_PATH/log/dotfiles.${timestamp%% *}.log"

    echo "[$timestamp]: $msg" | tee -a $logfile
}

