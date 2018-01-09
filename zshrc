# zshrc
export USER_DOTFILE_DIR="$HOME/workflow/dotfiles"
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="evanthegrayt_top_heavy"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"

setopt HIST_IGNORE_ALL_DUPS
setopt SH_FILE_EXPANSION
setopt EXTENDEDGLOB

# AUTOLOADED FUNCTIONS
autoload -U zmv

# ENABLED PLUGINS
plugins=(
sudo
ruby
git
osx
per-directory-history
history-substring-search
zsh-autosuggestions
zsh-syntax-highlighting
)

fpath=(~/bin/lib/zsh $fpath)

# Source ZSH files and shellrc
() {
    local file
    for file { source "$file" || echo "zshrc: could not source file [$file]" }
} $HOME/.opam/opam-init/init.zsh $ZSH/oh-my-zsh.sh $USER_DOTFILE_DIR/shellrc

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

if [[ -d $ZSH ]]; then
    bindkey -M emacs '^N' history-substring-search-down
    bindkey -M emacs '^P' history-substring-search-up
fi

