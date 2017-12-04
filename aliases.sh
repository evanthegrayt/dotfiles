# vi: set syntax=sh :

alias lrt='ls -lArth'
alias ls='ls -G'

alias vbrc="vim $USER_DOTFILE_DIR/bashrc"
alias vzrc="vim $USER_DOTFILE_DIR/zshrc"
alias vvrc="vim $USER_VIM_DIR/vimrc"
alias val="vim $USER_DOTFILE_DIR/aliases.sh"

alias diff='colordiff'
alias less='less -m -N -g -i -J --underline-special --SILENT'
alias untar='tar -zxvf'
alias rm='rm -v'
alias cp='cp -v'
alias mv='mv -v'
alias path='printf ${PATH//:/\\n};echo'
alias xed="$HOME/scripts/bin/exed"

alias ag="ag --color-line-number='07;01;38;5;131' --color-match='07;38;5;74' --color-path='07;01;38;5;131'"

alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app'
alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app'

alias vup="cd $HOME/workflow/vagrant-ique && vagrant up"
alias vssh="cd $HOME/workflow/vagrant-ique && vagrant ssh"
alias vhalt="cd $HOME/workflow/vagrant-ique && vagrant halt"

if [[ -n "$ZSH_NAME" ]]; then # ZSH ONLY ALIASES
    alias    zzmv='noglob zmv -W'
    alias -s out='vim'
    alias -s txt='vim'
    alias -s xls='open -a LibreOffice'
    alias -s xlsx='open -a LibreOffice'
    alias -s ods='open -a LibreOffice'
    alias -s odt='open -a LibreOffice'
fi

