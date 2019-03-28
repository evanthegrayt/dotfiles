# NOTE: Only edit this file if you know what you're doing! These are variables
# that I figured some people might want to edit, so I separated them from the
# main install script. The ones left in the actual script will probably never
# need to be changed.

##
# VIM_REPO: The `vim` repository to install.
readonly VIM_REPO='https://github.com/evanthegrayt/vimfiles.git'

##
# ZSH_CUSTOM_REPO: The `custom` directory repository for `oh-my-zsh`.
readonly ZSH_CUSTOM_REPO='https://github.com/evanthegrayt/oh-my-zsh-custom.git'

##
# BASH_CUSTOM_REPO: The `custom` directory repository for `bash_it`.
readonly BASH_CUSTOM_REPO='https://github.com/evanthegrayt/bash-it-custom.git'

##
# REPO_DIR: Directory to clone git repos into.
readonly REPO_DIR="$HOME/workflow"

##
# SCREENSHOT_DIR: On mac, where you'd like screenshots to be placed.
readonly SCREENSHOT_DIR="$HOME/Pictures/Screenshots"

##
# LOGFILE_TIMESTAMP: Timestamp used by log() function when adding messages.
readonly LOGFILE_TIMESTAMP="$( date "+%Y-%m-%d %H:%M:%S" )"

##
# LOGFILE_DATESTAMP: Datestamp that will be used for log file names.
readonly LOGFILE_DATESTAMP="$( date "+%Y-%m-%d" )"

