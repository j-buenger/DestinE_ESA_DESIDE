#!/bin/bash -e

if [ -d "output" ]
then
  rm -rf output
fi

mkdir output/

touch output/index.html

echo '<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta http-equiv="X-UA-Compatible" content="ie=edge" />
    <title>Documents</title>
  </head>
  <body>
    <h1>Documents</h1>
    <div>
      <ul>' >> output/index.html


DOCS="${BUILD_DOCS:-PMP SRS SVVP}"

for doc in $DOCS ; do
  echo "Building $doc"

  cd $doc

  mkdir ../output/$doc

  # Prepare output/ directory
  cp -r images ../output/$doc
  cp -r stylesheets ../output/$doc

  # Document Generation - using asciidoctor
  # HTML version
  asciidoctor -r asciidoctor-diagram -r asciidoctor-lists -D ../output/$doc index.adoc
  # PDF version
  asciidoctor-pdf -r asciidoctor-diagram -r asciidoctor-lists -D ../output/$doc -o VS_$doc.pdf index.adoc
  # DOCX version
  pandoc --from html --reference-doc ../bin/reference-styles.docx --to docx --output ../output/$doc/VS_$doc.docx ../output/$doc/index.html

  # Add links to the root index.html
  echo "        <li>$doc <a href=\"$doc/index.html\">HTML</a> <a href=\"$doc/VS_$doc.pdf\">PDF</a> <a href=\"$doc/VS_$doc.docx\">DOCX</a></li>" >> ../output/index.html

  cd ..
done


echo '      </ul>
    </div>
  </body>
</html>' >> output/index.html
