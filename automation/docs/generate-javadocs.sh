#!/bin/bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <MAIN_DIRECTORY_LOCATION> <OUTPUT_DIRECTORY>"
    exit 1
fi

MAIN_DIRECTORY_LOCATION=$1
OUTPUT_DIRECTORY=$2

JVM_PROJECTS="agama jans-auth-server jans-casa jans-config-api jans-core jans-fido2 jans-keycloak-link jans-link jans-lock jans-orm jans-scim"

for module in $JVM_PROJECTS; do
    echo "--------------------------------------------"
    echo "Processing module: $module"
    pom_file="$MAIN_DIRECTORY_LOCATION/$module/pom.xml"

    if [ ! -f "$pom_file" ]; then
        echo "Warning: POM file not found for module $module at $pom_file. Skipping module."
        continue
    fi

    echo "Generating Javadocs for $module"
    ( cd "$MAIN_DIRECTORY_LOCATION/$module" && mvn javadoc:javadoc -DoutputDirectory="../../$OUTPUT_DIRECTORY/$module" )
    echo "Javadocs generation complete for $module."

    echo "Finished processing module: $module"
    echo "--------------------------------------------"
done

echo "All modules processed."
