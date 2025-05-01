#!/bin/bash
set -euo pipefail
# The below variable represents the top level directory of the repository
MAIN_DIRECTORY_LOCATION=$1
OUTPUT_DIRECTORY=$2
RUST_PROJECTS="jans-cedarling"
for project in $RUST_PROJECTS
 do
   echo "Generating rust docs for: $project and all it's sub-modules"
   cd "$project"
   cargo doc --no-deps -p cedarling
   cp -rv target/doc ../../../cedarling
 done

