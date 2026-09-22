# Janssen developer docs

Hosts the API references for the most recent official Janssen release: javadocs,
Cedarling rustdocs (`cedarling` and `cedarling_wasm`) and the Cedarling Python
binding docs. Only the most recent release tag is hosted.

The repository root is not browsable; reach the references through the Janssen
documentation:

- [Janssen server javadocs](https://docs.jans.io/stable/janssen-server/reference/)
- [Cedarling interface reference](https://docs.jans.io/stable/cedarling/)

## How this repository is updated

Content is generated and pushed by the `Build: Developer docs` workflow in the
[jans](https://github.com/JanssenProject/jans) repository, which runs on every
`v*` release and replaces this repository with a single commit. Do not commit
generated docs by hand: the next release overwrites them.

## Generating the docs locally

```bash
git clone https://github.com/JanssenProject/jans.git
cd jans
git checkout <release-tag>

bash ./automation/docs/generate-javadocs.sh . ../out <release-tag>
bash ./automation/docs/generate-rustdocs.sh . ../out/cedarling
bash ./automation/docs/generate-python-docs.sh . ../out/cedarling-python
```
