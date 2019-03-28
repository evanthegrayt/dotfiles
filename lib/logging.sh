
print_log() {
    local file_to_print="$INSTALL_PATH/log/dotfiles.$LOGFILE_DATE_TO_PRINT.log"

    if [[ -f $file_to_print ]]; then
        echo "$( < $file_to_print )"
    else
        echo >&2 "Logfile [$file_to_print] does not exist."
        list_logfiles >&2
    fi
}

list_logfiles() {
    local logfile
    local logfiles

    logfiles=("$INSTALL_PATH"/log/*.log)

    if (( ${#logfiles} == 0 )); then
        echo 'No logfiles exist in `log/`'
    else
        echo 'Available logfiles are:'
        for logfile in ${logfiles[@]}; do
            echo $logfile
        done
    fi
}

log() {
    local msg="$@"

    echo "[$LOGFILE_TIMESTAMP]: $msg" | tee -a $LOGFILE
}

