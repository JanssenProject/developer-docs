#!/bin/bash
set -euo pipefail
# The below variable represents the top level directory of the repository
MAIN_DIRECTORY_LOCATION=$1
OUTPUT_DIRECTORY=$2
# add jans-keycloak-integration to the list below once https://github.com/JanssenProject/jans/issues/8057 is resolved
JVM_PROJECTS="agama jans-auth-server jans-casa jans-config-api jans-core jans-cedarling/bindings/cedarling-java jans-fido2 jans-keycloak-link jans-link jans-lock jans-orm jans-scim"
for module in $JVM_PROJECTS
 do
   echo "Generating javadocs for module: $module and all it's sub-modules"
   #condition to generate docs for Cedarling binding
   if [ $module =  "jans-cedarling/bindings/cedarling-java" ]; then
    BASE_DIR="./jans-cedarling/bindings/cedarling-java"
    RES_DIR="${BASE_DIR}/src/main/resources"
    KOTLIN_DIR="${BASE_DIR}/src/main/kotlin/io/jans/cedarling"
    # Create required directories
    mkdir -p "$RES_DIR" "$KOTLIN_DIR"
    # Download and rename shared library
    wget -q https://github.com/JanssenProject/jans/releases/download/nightly/libcedarling_uniffi-0.0.0.so -O "${RES_DIR}/libcedarling_uniffi.so"
    # Download, unzip and clean Kotlin bindings
    ZIP_PATH="${KOTLIN_DIR}/cedarling_uniffi-kotlin-0.0.0.zip"
    wget -q https://github.com/JanssenProject/jans/releases/download/nightly/cedarling_uniffi-kotlin-0.0.0.zip -O "$ZIP_PATH"
    unzip -q "$ZIP_PATH" -d "$KOTLIN_DIR"
    rm -f "$ZIP_PATH"
    mvn -f "$MAIN_DIRECTORY_LOCATION"/"$module"/pom.xml dokka:javadoc
    echo "getting locations where javadocs got generated"
    # Initial location where the Java docs will be generated
    doc_path_pattern="*/target/dokkaJavadoc"
    doc_subpath="target/dokkaJavadoc"
   else
    mvn -f "$MAIN_DIRECTORY_LOCATION"/"$module"/pom.xml javadoc:javadoc
    # Initial location where the Java docs will be generated
    doc_path_pattern="*/target/site/apidocs"
    doc_subpath="target/site/apidocs"
   fi
   echo "Move generated javadocs to respective doc site location"

   echo "getting locations where javadocs got generated"
   mapfile -t generated_doc_paths < <(find "$MAIN_DIRECTORY_LOCATION/$module" -type d -path "$doc_path_pattern" | sed "s|/$doc_subpath||")

   echo "move javadocs from each location to respective documentation site location"
   for source_path in "${generated_doc_paths[@]}"
   do
     target_path="$OUTPUT_DIRECTORY$source_path"
     # check if the directory `$source_path` exists, if not then create one
     echo "Copying javadocs from $source_path to $target_path"
     mkdir -p "$target_path" || echo "Directory $source_path already exists"
     cp -rv "$source_path/$doc_subpath/"* "$target_path/"
   done
 done