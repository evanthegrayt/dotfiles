# vi: set ft=sh:
[[ -f $HOME/.profile.local ]] && source $HOME/.profile.local

[[ $( uname -s ) == 'Linux' && -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && \
    source "$HOME/.bashrc"

