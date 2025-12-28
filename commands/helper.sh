# check if argument is a directory
is_directory() {
    if [ -d "$1" ]; then
        return 0
    else
        return 1
    fi
}

is_file() {
    if [ -f "$1" ]; then
        return 0
    else
        return 1
    fi
}

is_valid_name() {
    if [[ "$1" =~ ^[a-zA-Z_][a-zA-Z0-9_]*$ ]]; then
        return 0
    else
        return 1
    fi
}