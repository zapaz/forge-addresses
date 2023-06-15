#!/bin/bash

# sh writeJon.sh <file> <chainId> <key> <value>
#
# add a field in a JSON file, where root object has chainIds as fields
#
# {
#   "31337": {
#     "Test": "My test string",
#   }
# }
# by
# {
#   "31337": {
#     "Test": "My test string",
#     "Other": "Other test String"
#   }
# }
#
# what forge json cheatcodes can't do :-(

# Get the JSON string from file
json=$(cat $1)

# Set the field to find
# TODO add case zero or more spaces between ':' and '{'
to_find="\"$2\": {"
echo to find : $to_find

# Set the field to replace
to_replace="\"$2\": {\n    \"$3\": \"$4\", "
echo to replace : $to_replace

# Create a new JSON string with the added field
new_json=$(echo "$json" | sed s/"$to_find"/"$to_replace"/)

# Write the new JSON string to same file
echo "$new_json" > $1

