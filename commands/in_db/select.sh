#!/bin/bash

current_db=$1
table_name=$2
db_path="databases/$current_db"
table_path="$db_path/$table_name"

source ./commands/helper.sh

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

read -p "Enter column numbers to select (comma separated, e.g., 0,2): " col_nums_input
IFS=',' read -r -a col_nums <<< "$col_nums_input"

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

cut_indices=()
for num in "${col_nums[@]}"; do
    cut_indices+=("$((num + 1))")
done
cut_command=$(IFS=',' ; echo "${cut_indices[*]}")

echo ""

if [ -n "$where_clause" ]; then
    head -1 "$table_path" | cut -d',' -f"$cut_command" | tr ',' '\t' | column -t -s $'\t'
    grep_command="grep -E '^([^,]*,){${where_col_num}}$where_value(,|$)' \"$table_path\""
else
    grep_command="cat \"$table_path\""
fi

eval "$grep_command" | cut -d',' -f"$cut_command" | tr ',' '\t' | column -t -s $'\t'