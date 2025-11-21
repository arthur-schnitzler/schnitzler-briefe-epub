#!/bin/bash

# hacky way to make sure the script
# gets always run from parent-dir
# so relative paths get resolved the right way
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$script_dir/.."
# run script
./shellscripts/dl_saxon.sh
