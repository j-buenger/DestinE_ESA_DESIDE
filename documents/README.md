<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](https://github.com/thlorenz/doctoc)*

- [Build docker images or install dependencies](#build-docker-images-or-install-dependencies)
- [Generate the documentation](#generate-the-documentation)
- [Add a new document](#add-a-new-document)
- [Generate change tracking document](#generate-change-tracking-document)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Build docker images or install dependencies

```bash
docker build . -t deside-deliverables
```

or

```bash
gem install asciidoctor asciidoctor-diagram asciidoctor-pdf asciidoctor-lists coderay
```

## Generate the documentation

The following command:

```bash
docker run --rm -it -v $PWD/:/opt/documents/ deside-deliverables bash /opt/documents/bin/generate-docs.sh
```

or

```bash
bin/generate-docs.sh
```

generates the HTML and PDF versions of each of the documents and places the result
files with a directory `index.html` in the `output` folder. The env-variable
`BUILD_DOCS` controls which documents (in each sub-directory) are to be built.

## Add a new document

Copy the `template-doc` directory and name it to the document name of your choice.
Add your document name to the list of documents in the `BUILD_DOCS` environment
variable (and the defaults in the `bin/generate-docs.sh` script).

## Generate change tracking document

Working directory must be clean for git to switch between commits and generate
docx documents with change tracking enabled.

Following command create a zipped archive (update `-e` env variables accordingly) for each `doc` in target directory `output/doc/changes/` between `GIT_HASH_FROM` and `GIT_HASH_TO`.

```bash
# run in current directory (root of repo)
docker run --rm -it -e BUILD_DOCS="SRS" -e GIT_HASH_FROM=11ec4912f141cd9e6cd870bd6f9f394b6857fe8c -e GIT_HASH_TO=main -v $PWD/:/opt/documents/ deside-deliverables bash /opt/documents/bin/changetrack.sh
```
