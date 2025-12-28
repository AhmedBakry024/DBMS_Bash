#!/bin/bash

source ./commands/helper.sh

echo "Welcome to BSQL. for manual type 'MAN BSQL'"

while true; do
    read -p "bsql> " sql_command
    read -r -a sql_parts <<< "$sql_command"

    sql_parts[0]=${sql_parts[0]^^} 

    case "${sql_parts[0]}" in
        "CREATE")
            ./commands/out_db/create_db.sh "${sql_parts[1]}"
            ;;
        "DROP")
            ./commands/out_db/drop_db.sh "${sql_parts[1]}"
            ;;
        "USE")
            ./commands/in_db/db_menu.sh "${sql_parts[1]}"
            ;;
        "SHOW")
            sql_parts[1]=${sql_parts[1]^^}
            if [[ "${sql_parts[1]}" == "DATABASES" ]]; then
                ./commands/out_db/list_db.sh
            else
                echo "Syntax error"
            fi
            ;;
        "EXIT")
            break
            ;;
        "MAN")
            sql_parts[1]=${sql_parts[1]^^}
            if [[ "${sql_parts[1]}" != "BSQL" ]]; then
                echo "Syntax error"
                continue
            fi
            echo "Available SQL Commands:"
            echo "1. CREATE <database_name> - Create a new database."
            echo "2. DROP <database_name> - Drop an existing database."
            echo "3. USE <database_name> - Connect to a database."
            echo "4. SHOW DATABASES - List all databases."
            echo "5. EXIT - Exit SQL mode."
            ;;
        *)
            echo "Unsupported command."
            ;;
    esac
done