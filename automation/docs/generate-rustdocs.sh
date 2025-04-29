#!/bin/bash
set -euo pipefail
RUST_PROJECTS="jans-cedarling"
for project in $RUST_PROJECTS
 do
   echo "Generating rust docs for: $project and all it's sub-modules"
   cd "$project"
   cargo doc --no-deps -p cedarling
   echo "Move generated rust docs to respective doc site location"
   cp -r target/doc /home/runner/work/developer-docs/cedarling
 done
