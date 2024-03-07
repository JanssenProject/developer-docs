# javadocs

As we do not host the javadocs on the janssen repository, we use this repository to host the javadocs of the most recent janssen official release.

Please note we do not support hosting the javadocs for multiple tags, only the most recent release tag will be hosted here.

Please use the following link to access the javadocs for the most recent janssen release:

[https://docs.jans.io/stable/admin/reference/openapi/#javadocs](https://docs.jans.io/stable/admin/reference/openapi/#javadocs)

## How to generate the javadocs for a specific janssen release tag

1. Clone the janssen repository and checkout the release tag you want to generate the javadocs for
    ```bash
    git clone https://github.com/JanssenProject/jans.git
    cd jans
    git checkout <release-tag>
    ```

2. Generate the javadocs

    ```bash
    bash ./automation/docs/generate-javadocs.sh
    ```