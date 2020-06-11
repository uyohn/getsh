#!/bin/sh

# Prepare the JSON file
TMP_FILE=".build_json.json"

echo -e "{\n}" > $TMP_FILE

# Use $EDITOR to build the string
$EDITOR $TMP_FILE

# Cleanup
rm $TMP_FILE
