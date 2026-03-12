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
col_index=0
declare -A col_name_to_index
for col_def in "${columns[@]}"; do
    IFS=':' read -r col_name col_type <<< "$col_def"
    col_name_to_index["$col_name"]="$col_index"
    ((col_index++))
done

# Column selection: non-interactive if $3 provided, else interactive
if [ $# -ge 3 ]; then
    if [[ "$3" == "*" ]]; then
        col_nums=()
        for ((i=0; i<col_index; i++)); do
            col_nums+=("$i")
        done
    else
        IFS=',' read -r -a col_name_list <<< "$3"
        col_nums=()
        for cname in "${col_name_list[@]}"; do
            cname="${cname// /}"
            if [[ -v col_name_to_index["$cname"] ]]; then
                col_nums+=("${col_name_to_index[$cname]}")
            else
                echo "Column '$cname' does not exist in table '$table_name'."
                exit 1
            fi
        done
    fi
else
    echo "Available columns in table '$table_name':"
    idx=0
    for col_def in "${columns[@]}"; do
        IFS=':' read -r col_name col_type <<< "$col_def"
        echo "$idx) $col_name ($col_type)"
        ((idx++))
    done
    read -p "Enter column numbers to select (comma separated, e.g., 0,2): " col_nums_input
    IFS=',' read -r -a col_nums <<< "$col_nums_input"
fi

# WHERE condition: non-interactive if $4 provided (even if empty), else interactive
where_col_num=-1
where_value=""
if [ $# -ge 4 ]; then
    if [ -n "$4" ]; then
        IFS='=' read -r cond_col cond_value <<< "$4"
        if [[ -v col_name_to_index["$cond_col"] ]]; then
            where_col_num="${col_name_to_index[$cond_col]}"
            where_value="$cond_value"
        else
            echo "Column '$cond_col' does not exist in table '$table_name'."
            exit 1
        fi
    fi
else
    read -p "Do you want to add a WHERE condition? (y/n): " where_choice
    if [[ "$where_choice" =~ ^[Yy]$ ]]; then
        read -p "Enter the WHERE condition (e.g., column_name=value): " condition
        IFS='=' read -r cond_col cond_value <<< "$condition"
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
        where_col_num=$cond_col_index
        where_value="$cond_value"
    fi
fi

cut_indices=()
for num in "${col_nums[@]}"; do
    cut_indices+=("$((num + 1))")
done
cut_command=$(IFS=',' ; echo "${cut_indices[*]}")

echo ""

if [ "$where_col_num" -ge 0 ]; then
    head -1 "$table_path" | cut -d',' -f"$cut_command" | tr ',' '\t' | column -t -s $'\t'
    grep -E "^([^,]*,){${where_col_num}}${where_value}(,|$)" "$table_path" | tail -n +2 | cut -d',' -f"$cut_command" | tr ',' '\t' | column -t -s $'\t'
else
    cat "$table_path" | cut -d',' -f"$cut_command" | tr ',' '\t' | column -t -s $'\t'
fi