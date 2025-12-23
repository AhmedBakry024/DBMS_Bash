#!/bin/bash

while true; do
    echo "Menu:"
    echo "1) Create Database"
    echo "2) List Databases"
    echo "3) Connect to Database"
    echo "4) Drop Database"
    echo "5) Exit"
    read -p "Choose an option [1-5]: " choice

    case $choice in
        1)
            read -p "Enter database name to create: " dbname
            # echo "Creating database '$dbname'..."
            ./commands/out_db/create_db.sh "$dbname"
            ;;
        2)
            echo ""
            echo "Current Databases:"
            ./commands/out_db/list_db.sh
            echo ""
            ;;
        3)
            read -p "Enter database name to connect: " dbname
            echo "Connecting to database '$dbname'..."
            ./commands/in_db/db_menu.sh "$dbname"
            ;;
        4)
            read -p "Enter database name to drop: " dbname
            ./commands/out_db/drop_db.sh "$dbname"
            ;;
        5)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
    echo ""
done