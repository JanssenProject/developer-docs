#!/bin/bash
set -euo pipefail
RUST_PROJECTS="jans-cedarling"
for project in $RUST_PROJECTS
 do
   echo "Generating rust docs for: $project and all it's sub-modules"
   cd "$project"
   cargo doc --no-deps -p cedarling
 done

