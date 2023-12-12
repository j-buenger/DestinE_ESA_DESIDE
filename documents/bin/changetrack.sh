# Helper script to generate docx with change tracking enabled and showing changes between two commits
# usage inside docker container - PWD should be in root of the repository
# docker run --rm -it -e BUILD_DOCS="SRS" -e GIT_HASH_FROM=11ec4912f141cd9e6cd870bd6f9f394b6857fe8c -e GIT_HASH_TO=main -v $PWD/:/opt/documents/ deside-deliverables bash /opt/documents/bin/changetrack.sh

# initial cleanup
rm -rf output/
### CHANGE AS REQUIRED OR PASS FROM ENV
DOCS="${BUILD_DOCS:-ICD SDD}"
GIT_HASH_FROM="${GIT_HASH_FROM:-11ec4912f141cd9e6cd870bd6f9f394b6857fe8c}"
GIT_HASH_TO="${GIT_HASH_TO:-master}"
# needed because of different user creating host git folder than mounted inside container
git config --global --add safe.directory /opt/documents

for doc in $DOCS ; do
    cd $doc
    git checkout -q $GIT_HASH_FROM
    # take the reference style always from master, as does not have to exist in $FROM or $TO
    git checkout -q master -- ../bin/reference-styles.docx
    # copy static files
    mkdir -p ../output/$doc/$GIT_HASH_FROM
    cp -r images ../output/$doc/$GIT_HASH_FROM
    cp -r stylesheets ../output/$doc/$GIT_HASH_FROM
    # Document Generation - using asciidoctor
    # temporary HTML
    asciidoctor -r asciidoctor-diagram -r asciidoctor-lists --out-file ../output/$doc/$GIT_HASH_FROM/index.html index.adoc 
    # pandoc generate output 1 docx using a reference style docx for visuals
    pandoc --from html --reference-doc ../bin/reference-styles.docx --to docx --output ../output/$doc/$GIT_HASH_FROM/"$GIT_HASH_FROM".docx ../output/$doc/$GIT_HASH_FROM/index.html
    
    git checkout -q $GIT_HASH_TO
    git checkout -q master -- ../bin/reference-styles.docx
    mkdir ../output/$doc/$GIT_HASH_TO
    cp -r images ../output/$doc/$GIT_HASH_TO
    cp -r stylesheets ../output/$doc/$GIT_HASH_TO
    
    asciidoctor -r asciidoctor-diagram -r asciidoctor-lists --out-file ../output/$doc/$GIT_HASH_TO/index.html index.adoc
    # pandoc generate output 2 docx using a reference style docx for visuals
    pandoc --from html --reference-doc ../bin/reference-styles.docx --to docx --output ../output/$doc/$GIT_HASH_TO/"$GIT_HASH_TO".docx ../output/$doc/$GIT_HASH_TO/index.html
    
    mkdir ../output/$doc/changes
    # generate diff docx with change tracking, due to path problems separating embedded images to changes/media instead of inside docx
    pandiff ../output/$doc/$GIT_HASH_FROM/$GIT_HASH_FROM.docx ../output/$doc/$GIT_HASH_TO/$GIT_HASH_TO.docx -o ../output/$doc/changes/VS_"$doc""_""$GIT_HASH_TO"_changetracking.docx --extract-media=../output/$doc/changes/media --reference-doc=../bin/reference-styles.docx
    # cleanup temporary media directory
    cd ../output/$doc/changes
    rm -rf media/media
    # zip content to delivery
    zip -qr VS_"$doc""_""$GIT_HASH_TO".zip ./
    cd ../../../
done
