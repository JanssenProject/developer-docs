#!/bin/bash
set -euo pipefail
PYTHON_PROJECTS="jans-cedarling/bindings"
for project in $PYTHON_PROJECTS
 do
   echo "Generating python docs for: $project and all it's sub-modules"
   cd "$project"
   python -m pydoc -w cedarling_python
   mkdir -p ../../../cedarling-python || echo "Directory cedarling-python already exists"
   cp -rv cedarling_python.html ../../../cedarling-python/cedarling_python.html
 done
