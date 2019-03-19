readonly USAGE="USAGE: ${0##*/} [OPTIONS]"

readonly VIM_REPO='https://github.com/evanthegrayt/vimfiles.git'

readonly ZSH_CUSTOM_REPO='https://github.com/evanthegrayt/oh-my-zsh-custom.git'

readonly BASH_CUSTOM_REPO='https://github.com/evanthegrayt/bash-it-custom.git'

readonly BREW='https://raw.githubusercontent.com/Homebrew/install/master/install'

readonly OS="$( uname -s )"

readonly BREW_TAPS=(
$( grep '^\s*-' $INSTALL_PATH/lib/config/brew_taps.yml | cut -d' ' -f2- )
)

readonly BREW_CASKS=(
$( grep '^\s*-' $INSTALL_PATH/lib/config/brew_casks.yml | cut -d' ' -f2- )
)

readonly LOCAL_FILES=(
$( grep '^\s*-' $INSTALL_PATH/lib/config/local_files.yml | cut -d' ' -f2- )
)

readonly PERSONAL_REPOS=(
$( grep '^\s*-' $INSTALL_PATH/lib/config/personal_repos.yml | cut -d' ' -f2- )
)

readonly RUBY_GEMS=(
$( grep '^\s*-' $INSTALL_PATH/lib/config/ruby_gems.yml | cut -d' ' -f2- )
)

