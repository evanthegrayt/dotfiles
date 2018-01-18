# vi: set ft=sh:

[[ $( uname -s ) == 'Linux' && -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && \
    source "$HOME/.bashrc"

