source ./commands/helper.sh

db_path="databases/$1"
table_path="$db_path/$2"

if is_file "$table_path"; then
    echo "Table '$2' already exists in database '$1'."
    exit 1
else
    touch "$table_path"
fi

echo "Defining columns for table '$2'."
columns=()
isPKSet=false
while true; do
    read -p "Enter column name (or type 'done' to finish): " column_name
    if [ "$column_name" == "done" ]; then
        break
    fi
    while true; do
        read -p "Enter data type for column '$column_name' (int/string): " data_type
        data_type="${data_type,,}"
        if [[ "$data_type" == "int" ]] || [[ "$data_type" == "string" ]]; then
            break
        else
            echo "Invalid data type. Please enter 'int' or 'string'."
        fi
    done
    if [ "$isPKSet" = false ]; then
        read -p "Is this column a Primary Key? (y/n): " pk_choice
        if [[ "$pk_choice" =~ ^[Yy]$ ]]; then
            data_type="$data_type:pk"
            isPKSet=true
        fi
    fi
    columns+=("$column_name:$data_type")
done
IFS=',' eval 'echo "${columns[*]}"' >> "$table_path"
echo "Table '$2' created successfully in database '$1' with columns: ${columns[*]}."
