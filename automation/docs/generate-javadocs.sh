#!/bin/bash
set -euo pipefail
# The below variable represents the top level directory of the repository
MAIN_DIRECTORY_LOCATION=$1
OUTPUT_DIRECTORY=$2
# add jans-keycloak-integration to the list below once https://github.com/JanssenProject/jans/issues/8057 is resolved
JVM_PROJECTS="agama jans-auth-server jans-casa jans-config-api jans-core jans-fido2 jans-keycloak-link jans-link jans-lock jans-orm jans-scim"
for module in $JVM_PROJECTS
 do
   echo "Generating javadocs for module: $module and all it's sub-modules"
   mvn -f "$MAIN_DIRECTORY_LOCATION"/"$module"/pom.xml javadoc:javadoc

   echo "Move generated javadocs to respective doc site location"

   echo "getting locations where javadocs got generated"
   mapfile -t generated_doc_paths < <(find "$MAIN_DIRECTORY_LOCATION/$module" -type d  -path '*/target/site/apidocs' | sed 's/\/target\/site\/apidocs//')

   echo "move javadocs from each location to respective documentation site location"
   for source_path in "${generated_doc_paths[@]}"
   do
     # check if the directory `$source_path` exists, if not then create one
     mkdir -p "$OUTPUT_DIRECTORY""$source_path"/ || echo "Directory $source_path already exists"
     echo "copy javadocs for $source_path"
     cp -rv ./"$source_path"/target/site/apidocs/* "$OUTPUT_DIRECTORY""$source_path"/
   done
 done