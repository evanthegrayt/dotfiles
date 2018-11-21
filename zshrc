# zshrc

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
osx
per-directory-history
history-substring-search
zsh-autosuggestions
zsh-syntax-highlighting
exercism_completion
rails
vb
cdc
)

if [[ -d "$HOME/.oh-my-zsh" ]]; then
    export ZSH="$HOME/.oh-my-zsh"
    export ZSH_THEME="evanthegrayt_top_heavy"
    bindkey -M emacs '^N' history-substring-search-down
    bindkey -M emacs '^P' history-substring-search-up
    export REPO_DIRS=(
        $HOME/workflow
        $HOME/workflow/vagrant-ique/src
        $HOME/workflow/vagrant-dotcom/src
    )
fi

fpath=(~/bin/lib/zsh $fpath)

# Source ZSH files and shellrc
() {
    local file
    for file { [[ -f $file ]] && source "$file" }
} $HOME/.opam/opam-init/init.zsh $ZSH/oh-my-zsh.sh $HOME/.shellrc

[[ -f $HOME/.zshrc.local ]] && source $HOME/.zshrc.local

