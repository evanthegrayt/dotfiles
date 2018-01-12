# bashrc
export USER_DOTFILE_DIR="$HOME/workflow/dotfiles"

source $USER_DOTFILE_DIR/shellrc

[[ -n $HOSTNAME ]] && current_host=$HOSTNAME || current_host=$HOST

case $current_host in
    ique*|homeb*) Color="$RRED" ;;
    *adfitech*) Color="$RWHITE" ;;
    *) Color="$RBLUE" ;;
esac
Color2="$BBLACK"
Color3="$UBLACK"

export PS1=" \[$Color\](\[$Color2\]\u\[$Color\]@\[$Color2\]${current_host%%.*}\[$Color|${Color2}bash\[$Color\])\[$RESET\] \[$Color3\]\w\[$RESET\]\n \[$Color\](\[$Color2\]\A\$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/$Color|$Color3\1/')\[$RESET\]\[$Color\])=>\[$RESET\]"'${PS2c##*[$((PS2c=0))-9]} '
export PS2="\[$Color2\] Line \[$RESET\]\[$Color2\]"'$((PS2c=PS2c+1))'"\[$Color\])=>\[$RESET\] "
export PS4=" \[$Color2\]"'${LINENO}'"\[$Color\])=>\[$Reset\] "
unset Color Color2 Color3 current_host

# History Management
export HISTCONTROL=ignoreboth:erasedups
export HISTIGNORE="pwd"
export HISTSIZE=100000
export HISTTIMEFORMAT="[%m/%d][%R] "
shopt -s histappend

[[ -d $HOME/.bash_it ]] && export BASH_IT="$HOME/.bash_it"

bind -x '"\C-l": clear'

