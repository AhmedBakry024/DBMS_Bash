#!/bin/bash

source commands/helper.sh

if is_directory "databases/$1"; then
    echo "Database '$1' already exists."
elif ! is_valid_name "$1"; then
    echo "Invalid database name '$1'. Database names must start with a letter and can contain only letters, numbers, and underscores."
else
    mkdir -p "databases/$1"
    echo "Database '$1' created successfully."
fi
