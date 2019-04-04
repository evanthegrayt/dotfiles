#==============================================================================#
#>        File: lib/install_helpers.sh                                         #
#> Description: Functions used by install scripts.                             #
#>      Author: Evan Gray                                                      #
#==============================================================================#

abort() {
    local msg=("$@")

    printf "%s\n" "${msg[@]}" >&2
    exit 1
}

array_includes() {
    local match="$1"
    local element
    shift

    for element; do [[ "$element" == "$match" ]] && return 0; done

    return 1
}

print_help() {
    echo $USAGE
    echo "$( < $INSTALL_PATH/lib/help_menu.txt )"

    exit 0
}

is_ignored() {
    local file="$1"

    grep -q "^\s*-\s*$file\s*$" $INSTALL_PATH/config/ignore.yml
}

read_yaml() {
    local file=$1

    grep '^\s*-' $INSTALL_PATH/config/$file.yml | cut -d' ' -f2-
}


git_directory_is_clean() {
    # TODO this isn't working properly now... weird.
    # taken from https://www.spinics.net/lists/git/msg142043.html
    # Update the index
    local err=0

    git update-index -q --ignore-submodules --refresh

    # Disallow unstaged changes in the working tree
    if ! git diff-files --quiet --ignore-submodules --; then
        echo >&2 "You have unstaged changes."
        git diff-files --name-status -r --ignore-submodules -- >&2
        err=1
    fi

    # Disallow uncommitted changes in the index
    if ! git diff-index --cached --quiet HEAD --ignore-submodules --; then
        echo >&2 "Your index contains uncommitted changes."
        git diff-index --cached --name-status -r --ignore-submodules HEAD -- >&2
        err=1
    fi

    if (( $err == 1 )); then
        echo >&2 "Please commit or stash them."
    fi

    return $err
}

validate_constants() {
    local not_set=()
    local const

    for const in ${CONSTANTS[@]}; do
        [[ -z ${!const} ]] && not_set+=($const)
    done

    if (( ${#not_set[@]} == 0 )); then
        return 0
    fi
    log "${not_set[@]} must all be set in '$INSTALL_PATH/config/constants.sh'" \
        ' for all features to work properly!'
    printf "Continue anyway? (y/n): "
    read
    case $REPLY in
        y|Y) log 'User chose to continue.'   ;;
        n|N) exit                            ;;
        *)   abort 'Invalid input. Exiting.' ;;
    esac
}

