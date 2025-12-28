#!/bin/bash

dbs=$(ls databases/)

if [ -n "$dbs" ]; then
  echo "Databases:"
  echo "$dbs"
else
  echo "No databases found."
fi