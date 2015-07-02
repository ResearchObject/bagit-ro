#!/bin/sh
cd example1
curl https://gist.githubusercontent.com/anonymous/7fe620279ea4988a5a1e/raw/e55d9ea6af35ea67cfaf47b03a2b71f9026325fd/external.txt > data/external.txt
md5sum data/* > manifest-md5.txt
sha1sum data/* > manifest-sha1.txt
rm data/external.txt # :)
cd ..
rm -f example1.zip
zip -q -r example1.zip example1
echo "Built BagIt example1.zip"


rm -f example1.bundle.zip
cd example1
echo -n application/vnd.wf4ever.robundle+zip > mimetype
zip -q -0 -X ../example1.bundle.zip mimetype
rm mimetype
zip -q -r ../example1.bundle.zip .
echo "Built RO Bundle example1.bundle.zip"
cd ..
