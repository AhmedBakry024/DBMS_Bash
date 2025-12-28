#!/bin/bash

source commands/helper.sh

if is_directory "databases/$1"; then
    rm -rf "databases/$1"
    echo "Database '$1' dropped successfully."
else
    echo "Database '$1' does not exist."
fi