tables=$(ls "databases/$1")

# see if tables is not empty
if [ -n "$tables" ]; then
  echo "Tables in the database:"
  echo "$tables"
else
  echo "No tables found in the database."
fi