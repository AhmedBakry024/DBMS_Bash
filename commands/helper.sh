# check if argument is a directory
is_directory() {
    if [ -d "$1" ]; then
        return 0
    else
        return 1
    fi
}