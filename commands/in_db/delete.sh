#!/bin/bash

source ./commands/helper.sh

current_db=$1
table_name=$2
db_path="databases/$current_db"
table_path="$db_path/$table_name"


if ! is_file "$table_path"; then
    echo "Table '$table_name' does not exist in database '$current_db'."
    exit 1
fi

read -p "Enter the condition for deletion (e.g., column_name=value): " condition
IFS='=' read -r cond_col cond_value <<< "$condition"


# Get the column index for the condition
IFS=',' read -r -a columns < "$table_path"
cond_col_index=-1
for i in "${!columns[@]}"; do
    IFS=':' read -r col_name col_type <<< "${columns[$i]}"
    if [[ "$col_name" == "$cond_col" ]]; then
        cond_col_index=$i
        break
    fi
done
if [ $cond_col_index -eq -1 ]; then
    echo "Column '$cond_col' does not exist in table '$table_name'."
    exit 1
fi

temp_file="$(mktemp)"
{
    IFS=',' read -r header_line
    echo "$header_line" > "$temp_file"
    while IFS=',' read -r -a row; do
        if [[ "${row[$cond_col_index]}" != "$cond_value" ]]; then
            echo "${row[*]}" | tr ' ' ','
        fi
    done
} < "$table_path" >> "$temp_file"
mv "$temp_file" "$table_path"
echo "Rows matching condition '$condition' have been deleted from table '$table_name' in database '$current_db'."