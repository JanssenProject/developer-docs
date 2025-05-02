#!/bin/bash
set -euo pipefail
PYTHON_PROJECTS="jans-cedarling/bindings/cedarling_python"
for project in $PYTHON_PROJECTS
 do
   echo "Generating python docs for: $project and all it's sub-modules"
   cd "$project"
   python -m pydoc -w cedarling_python
 done
