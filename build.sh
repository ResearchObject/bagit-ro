#!/bin/sh
set -e
cd example1
curl https://gist.githubusercontent.com/anonymous/7fe620279ea4988a5a1e/raw/e55d9ea6af35ea67cfaf47b03a2b71f9026325fd/external.txt > data/external.txt

sha512sum data/*.* data/provenance/* > manifest-sha512.txt
rm -f data/external.txt # :)

sha512sum manifest* fetch.txt bag*txt > tagmanifest-sha512.txt

cd ..
BAGIT=example1.bagit.zip
rm -f $BAGIT
zip -q -r $BAGIT example1
echo Built BagIt $BAGIT

