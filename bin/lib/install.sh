#!/usr/bin/env bash

INSTALL_LIB_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
INSTALL_BIN_DIR="$(cd -- "$INSTALL_LIB_DIR/.." && pwd -P)"
INSTALL_PATH="$(cd -- "$INSTALL_BIN_DIR/.." && pwd -P)"
INSTALL_TARGET_DIR="$INSTALL_BIN_DIR/yadem.d"
INSTALL_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/yadem"
INSTALL_LOG="${YADEM_LOG:-$INSTALL_CACHE_DIR/install.log}"
DRY_RUN="${DRY_RUN:-false}"
INSTALL_TARGET="${INSTALL_TARGET:-yadem}"
INSTALL_LOG_WRITTEN=false
INSTALL_LOG_FAILED=false

YADEM_DOTFILES_DIR="${YADEM_DOTFILES_DIR:-$INSTALL_PATH/dotfiles}"
YADEM_REPO_DIR="${YADEM_REPO_DIR:-$HOME/workflow}"
YADEM_VIM_REPO="${YADEM_VIM_REPO:-https://github.com/evanthegrayt/vimfiles.git}"
YADEM_ZSH_REPO="${YADEM_ZSH_REPO:-https://github.com/ohmyzsh/ohmyzsh.git}"
YADEM_ZSH_CUSTOM_REPO="${YADEM_ZSH_CUSTOM_REPO:-https://github.com/evanthegrayt/oh-my-zsh-custom.git}"
YADEM_BASH_REPO="${YADEM_BASH_REPO:-https://github.com/Bash-it/bash-it.git}"
YADEM_BASH_CUSTOM_REPO="${YADEM_BASH_CUSTOM_REPO:-https://github.com/evanthegrayt/bash-it-custom.git}"
YADEM_SCREENSHOT_DIR="${YADEM_SCREENSHOT_DIR:-$HOME/Pictures/Screenshots}"
YADEM_ALL_TARGETS=(${YADEM_ALL_TARGETS:-homebrew brew repos gems vim zsh bash italics dotfiles})
YADEM_GEMS=(${YADEM_GEMS:-standard spoonerize standup_md})
YADEM_REPOS=(${YADEM_REPOS:-})
YADEM_LOCAL_FILES=(${YADEM_LOCAL_FILES:-inputrc bashrc shellrc zshrc profile aliases irbrc pryrc cshrc bash_profile})
YADEM_DOTFILES_IGNORE=(${YADEM_DOTFILES_IGNORE:-README.md LICENSE xterm-256color.terminfo})
YADEM_LOCALIZE_EXISTING="${YADEM_LOCALIZE_EXISTING:-false}"

list_targets() {
    local target

    for target in "$INSTALL_TARGET_DIR"/*; do
        [[ -f "$target" ]] || continue
        printf "%s\n" "${target##*/}"
    done
}

load_yadem_config() {
    local default_config="$INSTALL_PATH/config/yademrc"
    local user_config="${YADEM_CONFIG:-$HOME/.yademrc}"

    if [[ -f "$default_config" ]]; then
        . "$default_config"
    fi

    if [[ -f "$user_config" && "$user_config" != "$default_config" ]]; then
        . "$user_config"
    fi
}

array_contains() {
    local needle="$1"
    local item
    shift

    for item; do
        [[ "$item" == "$needle" ]] && return
    done

    return 1
}

require_command() {
    local command_name="$1"

    if command -v "$command_name" >/dev/null 2>&1; then
        return
    fi

    say_and_log missing-command "$command_name is required"
    return 1
}

brew_executable() {
    local brew_path

    if command -v brew >/dev/null 2>&1; then
        command -v brew
        return
    fi

    for brew_path in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
        if [[ -x "$brew_path" ]]; then
            printf "%s\n" "$brew_path"
            return
        fi
    done

    return 1
}

log_event() {
    local action="$1"
    shift

    if mkdir -p "$(dirname -- "$INSTALL_LOG")" 2>/dev/null &&
        printf "%s %s %s %s\n" "$(date +%Y-%m-%dT%H:%M:%S%z)" "$INSTALL_TARGET" "$action" "$*" 2>/dev/null >> "$INSTALL_LOG"; then
        INSTALL_LOG_WRITTEN=true
        return
    fi

    if [[ "$INSTALL_LOG_FAILED" != true ]]; then
        printf "Warning: could not write install log: %s\n" "$INSTALL_LOG" >&2
    fi

    INSTALL_LOG_FAILED=true
}

say() {
    printf "%s\n" "$*"
}

say_and_log() {
    local action="$1"
    shift

    say "$*"
    log_event "$action" "$*"
}

log_status_message() {
    if [[ "$INSTALL_LOG_WRITTEN" == true ]]; then
        printf "Log written to %s\n" "$INSTALL_LOG"
    elif [[ "$INSTALL_LOG_FAILED" == true ]]; then
        printf "Log could not be written to %s\n" "$INSTALL_LOG"
    else
        printf "No log entries written.\n"
    fi
}

backup_path_for() {
    local target="$1"
    local name="${target##*/}"
    local backup
    local counter

    name="${name#.}"
    backup="$INSTALL_CACHE_DIR/$name.$(date +%F)"

    if [[ ! -e "$backup" && ! -L "$backup" ]]; then
        printf "%s\n" "$backup"
        return
    fi

    counter=1
    while [[ -e "$backup.$counter" || -L "$backup.$counter" ]]; do
        counter=$((counter + 1))
    done

    printf "%s\n" "$backup.$counter"
}
