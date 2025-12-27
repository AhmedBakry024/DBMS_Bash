#!/bin/bash

source ./commands/helper.sh

current_db=$1
db_path="databases/$current_db"

if ! is_directory "$db_path"; then
    echo "Database '$current_db' does not exist."
    exit 1
fi

echo ""
while true; do
    echo "Database Menu for '$current_db':"
    echo "1) Create Table"
    echo "2) List Tables"
    echo "3) Drop Table"
    echo "4) Insert into Table"
    echo "5) Select from Table"
    echo "6) Delete from Table"
    echo "7) Update Table"
    echo "8) Back to Main Menu"
    read -p "Choose an option [1-8]: " choice

    case $choice in
        1)
            read -p "Enter table name to create: " tablename
            ./commands/in_db/create_table.sh "$current_db" "$tablename"
            ;;
        2)
            echo ""
            # echo "Current Tables in '$current_db':"
            ./commands/in_db/list_tables.sh "$current_db"
            echo ""
            ;;
        3)
            read -p "Enter table name to drop: " tablename
            ./commands/in_db/drop_table.sh "$current_db" "$tablename"
            ;;
        4)
            read -p "Enter table name to insert into: " tablename
            ./commands/in_db/insert.sh "$current_db" "$tablename"
            ;;
        5)
            read -p "Enter table name to select from: " tablename
            ./commands/in_db/select.sh "$current_db" "$tablename"
            ;;
        6)
            read -p "Enter table name to delete from: " tablename
            ./commands/in_db/delete.sh "$current_db" "$tablename"
            ;;
        7)
            read -p "Enter table name to update: " tablename
            ./commands/in_db/update.sh "$current_db" "$tablename"
            ;;
        8)
            echo "Returning to Main Menu..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo ""
done