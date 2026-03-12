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
            current_db="${sql_parts[1]}"
            db_path="databases/$current_db"
            if ! is_directory "$db_path"; then
                echo "Database '$current_db' does not exist."
                continue
            fi
            echo "Connected to database '$current_db'."
            while true; do
                read -p "bsql [$current_db]> " db_sql_command
                read -r -a db_parts <<< "$db_sql_command"
                db_parts[0]=${db_parts[0]^^}

                case "${db_parts[0]}" in
                    "CREATE")
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" == "TABLE" ]]; then
                            ./commands/in_db/create_table.sh "$current_db" "${db_parts[2]}"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "SHOW")
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" == "TABLES" ]]; then
                            ./commands/in_db/list_tables.sh "$current_db"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "DROP")
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" == "TABLE" ]]; then
                            ./commands/in_db/drop_table.sh "$current_db" "${db_parts[2]}"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "INSERT")
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" == "INTO" ]]; then
                            ./commands/in_db/insert.sh "$current_db" "${db_parts[2]}"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "SELECT")
                        # SELECT col1,col2 FROM table [WHERE col=val]
                        from_index=-1
                        for i in "${!db_parts[@]}"; do
                            if [[ "${db_parts[$i]^^}" == "FROM" ]]; then
                                from_index=$i
                                break
                            fi
                        done
                        if [ "$from_index" -eq -1 ]; then
                            echo "Syntax error: Missing FROM clause"
                        else
                            cols=""
                            for ((i=1; i<from_index; i++)); do
                                cols+="${db_parts[$i]}"
                            done
                            cols="${cols// /}"
                            table_name="${db_parts[$((from_index+1))]}"
                            where_condition=""
                            for ((i=from_index+2; i<${#db_parts[@]}; i++)); do
                                if [[ "${db_parts[$i]^^}" == "WHERE" ]]; then
                                    where_condition="${db_parts[$((i+1))]}"
                                    break
                                fi
                            done
                            ./commands/in_db/select.sh "$current_db" "$table_name" "$cols" "$where_condition"
                        fi
                        ;;
                    "DELETE")
                        # DELETE FROM table WHERE col=val
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" == "FROM" ]]; then
                            table_name="${db_parts[2]}"
                            where_condition=""
                            for ((i=3; i<${#db_parts[@]}; i++)); do
                                if [[ "${db_parts[$i]^^}" == "WHERE" ]]; then
                                    where_condition="${db_parts[$((i+1))]}"
                                    break
                                fi
                            done
                            ./commands/in_db/delete.sh "$current_db" "$table_name" "$where_condition"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "UPDATE")
                        # UPDATE table SET col=val [WHERE col=val]
                        table_name="${db_parts[1]}"
                        db_parts[2]=${db_parts[2]^^}
                        if [[ "${db_parts[2]}" == "SET" ]]; then
                            set_clause="${db_parts[3]}"
                            where_condition=""
                            for ((i=4; i<${#db_parts[@]}; i++)); do
                                if [[ "${db_parts[$i]^^}" == "WHERE" ]]; then
                                    where_condition="${db_parts[$((i+1))]}"
                                    break
                                fi
                            done
                            ./commands/in_db/update.sh "$current_db" "$table_name" "$set_clause" "$where_condition"
                        else
                            echo "Syntax error"
                        fi
                        ;;
                    "EXIT")
                        echo "Disconnected from '$current_db'."
                        break
                        ;;
                    "MAN")
                        db_parts[1]=${db_parts[1]^^}
                        if [[ "${db_parts[1]}" != "BSQL" ]]; then
                            echo "Syntax error"
                            continue
                        fi
                        echo "Available SQL Commands (in database '$current_db'):"
                        echo "1. CREATE TABLE <table_name>                           - Create a new table."
                        echo "2. SHOW TABLES                                         - List all tables."
                        echo "3. DROP TABLE <table_name>                             - Drop a table."
                        echo "4. INSERT INTO <table_name>                            - Insert a record (interactive)."
                        echo "5. SELECT <col1,col2|*> FROM <table> [WHERE col=val]  - Query rows."
                        echo "6. DELETE FROM <table_name> WHERE <col>=<val>         - Delete matching rows."
                        echo "7. UPDATE <table_name> SET <col>=<val> [WHERE col=val] - Update rows."
                        echo "8. EXIT                                                - Disconnect from database."
                        ;;
                    "")
                        ;;
                    *)
                        echo "Unsupported command."
                        ;;
                esac
            done
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
            echo "2. DROP <database_name>   - Drop an existing database."
            echo "3. USE <database_name>    - Connect to a database (enters DB SQL mode)."
            echo "4. SHOW DATABASES         - List all databases."
            echo "5. EXIT                   - Exit SQL mode."
            echo ""
            echo "After connecting with USE, type 'MAN BSQL' for in-database commands."
            ;;
        *)
            echo "Unsupported command."
            ;;
    esac
done