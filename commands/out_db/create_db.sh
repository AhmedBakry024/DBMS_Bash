source commands/helper.sh

# to create a database I should check if the database already exists or not by checking if a directory with the database name exists, the database name will be passed as an argument to the script
if is_directory "databases/$1"; then
    echo "Database '$1' already exists."
else
    mkdir "databases/$1"
    echo "Database '$1' created successfully."
fi