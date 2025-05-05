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

# List of Maven projects. Adjust as needed.
JVM_PROJECTS="agama jans-auth-server jans-casa jans-config-api jans-core jans-fido2 jans-keycloak-link jans-link jans-lock jans-orm jans-scim"

for module in $JVM_PROJECTS; do
    echo "--------------------------------------------"
    echo "Processing module: $module"
    pom_file="$MAIN_DIRECTORY_LOCATION/$module/pom.xml"

    if [ ! -f "$pom_file" ]; then
        echo "Warning: POM file not found for module $module at expected location ($pom_file). Skipping module."
        continue
    fi

    echo "Generating Javadocs for $module and its sub-modules"
    ( cd "$MAIN_DIRECTORY_LOCATION/$module" && mvn javadoc:javadoc )
    echo "Javadocs generation complete for $module"
    echo "--------------------------------------------"

    echo "Searching for generated Javadoc directories within $module:"
    mapfile -t generated_doc_paths < <(find "$MAIN_DIRECTORY_LOCATION/$module" -type d $ -path '*/target/site/apidocs' -o -path '*/target/site/*apidocs' $ 2>/dev/null | sed 's#/target/site/apidocs##; s#/target/site/[^/]*apidocs##')

    if [ ${#generated_doc_paths[@]} -eq 0 ]; then
        echo "Warning: No Javadoc generation directory found for module $module"
        continue
    fi

    echo "Found the following base directories for generated docs:"
    for base_dir in "${generated_doc_paths[@]}"; do
        echo "  --> $base_dir"
    done

    # For each found location, attempt to copy the generated Javadocs.
    for base_dir in "${generated_doc_paths[@]}"; do
        src_dir="$base_dir/target/site/apidocs"
        if [ ! -d "$src_dir" ]; then
            echo "Warning: Source directory $src_dir does not exist. Skipping copy for this location."
            continue
        fi

        # Preserve the folder structure in the destination directory.
        dest_dir="$OUTPUT_DIRECTORY$base_dir"
        echo "Preparing to copy Javadocs from $src_dir to $dest_dir"
        mkdir -p "$dest_dir" || echo "Directory $dest_dir already exists"

        echo "Copying files from $src_dir to $dest_dir"
        cp -rv "$src_dir/"* "$dest_dir/"
    done
    echo "Finished processing module: $module"
    echo "--------------------------------------------"
done

echo "All modules processed."
