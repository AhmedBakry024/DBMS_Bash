#! /bin/bash

current_db=$1
table_name=$2
db_path="databases/$current_db"
table_path="$db_path/$table_name"

if [ ! -f "$table_path" ]; then
    echo "Table '$table_name' does not exist in database '$current_db'."
    exit 1
fi

IFS=',' read -r -a columns < "$table_path"
declare -A col_types
declare -A col_names
pk_column=""
for col_def in "${columns[@]}"; do
    IFS=':' read -r col_name col_type <<< "$col_def"
    col_names["$col_name"]="$col_name"
    if [[ "$col_type" == *":pk" ]]; then
        col_types["$col_name"]="${col_type%:pk}"
        pk_column="$col_name"
    else
        col_types["$col_name"]="$col_type"
    fi
done

declare -A new_record
for col_name in "${!col_names[@]}"; do
    while true; do
        read -p "Enter value for column '$col_name' (${col_types[$col_name]}): " value
        if [[ "${col_types[$col_name]}" == "int" ]]; then
            if ! [[ "$value" =~ ^-?[0-9]+$ ]]; then
                echo "Invalid input. Please enter an integer value."
                continue
            fi
        fi
        if [[ "$col_name" == "$pk_column" ]]; then
            if grep -q "^$value," "$table_path"; then
                echo "Primary Key constraint violation: value '$value' for column '$col_name' already exists."
                continue
            fi
        fi
        new_record["$col_name"]="$value"
        break
    done
done

record_line=""
for col_name in "${!col_names[@]}"; do
    record_line+="${new_record[$col_name]},"
done
record_line="${record_line%,}"

echo "$record_line" >> "$table_path"
echo "Record inserted successfully into table '$table_name' in database '$current_db'."

