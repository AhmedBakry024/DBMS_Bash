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

IFS=',' read -r -a columns < "$table_path"
echo "Available columns in table '$table_name':"
col_index=0
declare -A col_map
for col_def in "${columns[@]}"; do
    IFS=':' read -r col_name col_type <<< "$col_def"
    echo "$col_index) $col_name ($col_type)"
    col_map["$col_index"]="$col_name"
    ((col_index++))
done

read -p "Enter the column number to update: " update_col_num
update_col_name="${col_map[$update_col_num]}"
read -p "Enter the new value for '$update_col_name': " new_value

read -p "Do you want to add a WHERE condition? (y/n): " where_choice
where_clause=""
if [[ "$where_choice" =~ ^[Yy]$ ]]; then
    read -p "Enter the WHERE condition (e.g., column_name=value): " condition
    IFS='=' read -r cond_col cond_value <<< "$condition"
    
    IFS=',' read -r -a columns_check < "$table_path"
    cond_col_index=-1
    for i in "${!columns_check[@]}"; do
        IFS=':' read -r col_name col_type <<< "${columns_check[$i]}"
        if [[ "$col_name" == "$cond_col" ]]; then
            cond_col_index=$i
            break
        fi
    done
    if [ $cond_col_index -eq -1 ]; then
        echo "Column '$cond_col' does not exist in table '$table_name'."
        exit 1
    fi
    where_col_num=$cond_col_index
    where_value="$cond_value"
    where_clause="$cond_col='$cond_value'"
fi

temp_file="$(mktemp)"
{
    IFS=',' read -r header_line
    echo "$header_line" > "$temp_file"
    while IFS=',' read -r -a row; do
        if [ -n "$where_clause" ]; then
            if [[ "${row[$where_col_num]}" == "$where_value" ]]; then
                row[$update_col_num]="$new_value"
            fi
        else
            row[$update_col_num]="$new_value"
        fi
        (IFS=','; echo "${row[*]}")
    done
} < "$table_path" >> "$temp_file"
mv "$temp_file" "$table_path"
echo "Table '$table_name' in database '$current_db' has been updated."