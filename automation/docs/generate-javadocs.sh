#!/bin/bash
set -euo pipefail
#set -x  # Uncomment for step-by-step debugging output

# Usage: script <MAIN_DIRECTORY_LOCATION> <OUTPUT_DIRECTORY>
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <MAIN_DIRECTORY_LOCATION> <OUTPUT_DIRECTORY>"
    exit 1
fi

MAIN_DIRECTORY_LOCATION=$1
OUTPUT_DIRECTORY=$2

JVM_PROJECTS="agama jans-auth-server jans-casa jans-config-api jans-core jans-fido2 jans-keycloak-link jans-link jans-lock jans-orm jans-scim  jans-keycloak-integration"

for module in $JVM_PROJECTS
do
    echo "--------------------------------------------"
    echo "Processing module: $module"
    echo "Generating Javadocs for $module and its sub-modules"

    mvn -f "$MAIN_DIRECTORY_LOCATION/$module/pom.xml" javadoc:javadoc

    echo "Javadocs generation complete for $module"
    echo "--------------------------------------------"

    echo "Searching for generated Javadoc directories within $module:"
    mapfile -t generated_doc_paths < <(find "$MAIN_DIRECTORY_LOCATION/$module" -type d $ -path '*/target/site/apidocs' -o -path '*/target/site/*apidocs' $ | sed 's/\/target\/site\/apidocs//;s/\/target\/site\/.*apidocs//')

    if [ ${#generated_doc_paths[@]} -eq 0 ]; then
        echo "Warning: No Javadoc generation directory found for module $module"
        continue
    fi

    echo "Found the following base directories for generated docs:"
    for dir in "${generated_doc_paths[@]}"; do
        echo "  --> $dir"
    done

    # For each found location, attempt to copy the generated Javadocs.
    for base_path in "${generated_doc_paths[@]}"
    do
        src_dir="$base_path/target/site/apidocs"
        if [ ! -d "$src_dir" ]; then
            echo "Warning: Source directory $src_dir does not exist. Skipping copy for this location."
            continue
        fi

        dest_dir="$OUTPUT_DIRECTORY${base_path}"
        echo "Preparing to copy Javadocs from $src_dir to $dest_dir"
        mkdir -p "$dest_dir" || echo "Directory $dest_dir already exists"

        # Copy files from source to destination
        echo "Copying files..."
        cp -rv "$src_dir/"* "$dest_dir/"
    done

    echo "Finished processing module: $module"
    echo "--------------------------------------------"
done

echo "All modules processed."
