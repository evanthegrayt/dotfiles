# zshrc
# ENVIRONMENTAL VARIABLES
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="evanthegrayt_top_heavy"
export DISABLE_AUTO_UPDATE="true"
export ENABLE_CORRECTION="true"
export COMPLETION_WAITING_DOTS="true"
export HIST_STAMPS="yyyy-mm-dd"
export USER_DOTFILE_DIR="$HOME/workflow/dotfiles"
export USER_VIM_DIR="$HOME/.vim"
# export CASE_SENSITIVE="true"
# export HYPHEN_INSENSITIVE="true"
# export DISABLE_LS_COLORS="true"
# export DISABLE_AUTO_TITLE="true"
# export DISABLE_UNTRACKED_FILES_DIRTY="true"
# export ZSH_CUSTOM=/path/to/new-custom-folder
# export UPDATE_ZSH_DAYS=13
# export ARCHFLAGS="-arch x86_64"
# export SSH_KEY_PATH="$HOME/.ssh/dsa_id"

# ZSH OPTIONS
setopt HIST_IGNORE_ALL_DUPS
setopt SH_FILE_EXPANSION
setopt EXTENDEDGLOB

# SHELL OPTIONS
unset MAILCHECK

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
    for file {
        [[ -f "$file" ]] && source "$file" || \
        print "[$file] does not exist! (Error from shellrc file)"
    }
} $HOME/.opam/opam-init/init.zsh $ZSH/oh-my-zsh.sh $USER_DOTFILE_DIR/shellrc


# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"

if [[ -n $ZSH ]]; then
    bindkey -M emacs '^N' history-substring-search-down
    bindkey -M emacs '^P' history-substring-search-up
fi

# vi: set syntax=zsh :

