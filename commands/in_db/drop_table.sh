#!/bin/bash

source ./commands/helper.sh

table_path="databases/$1/$2"

if is_file "$table_path"; then
    rm "$table_path"
    echo "Table '$2' dropped successfully from database '$1'."
else
    echo "Table '$2' does not exist in database '$1'."
fi