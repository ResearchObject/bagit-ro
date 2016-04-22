#!/bin/sh

set -e

if [ -z "$1" ] ; then
  echo "Usage:" $0 "bundletoconvert.ro.zip"
  exit 1
fi


name=`basename $1 | sed s/.zip// | sed s/.ro//`
tmpdir=`mktemp -d`
dir="$tmpdir/$name"
mkdir -p $dir

unzip "$1" -d "$dir"

curdir=`pwd`
cd $dir


rm -f mimetype

mkdir .data
mv * .data/
mv .data data
mv .ro metadata

# Fix wrong relative path in "content": properties from SEEK
#sed -i 's,"content": ","content": "../,' metadata/manifest.json

# Convert "/" to relative paths
sed -i 's,"/,"../,' metadata/manifest.json

# Mark it as a bagit bag
echo BagIt-Version: 0.97 > bagit.txt
echo Tag-File-Character-Encoding: UTF-8 >> bagit.txt

# that comply with https://github.com/ResearchObject/bagit-ro
echo BagIt-Profile-Identifier: https://w3id.org/ro/bagit/profile > bag-info.txt

cd ..

wget https://github.com/LibraryOfCongress/bagit-java/releases/download/v4.12.0/bagit-4.12.0.tar
tar xfv bagit*tar
# NOTE: The below won't run on tmpfs due to noexec mount flag
bagit*/bin/bagit baginplace "$name"
# or:
#docker run -v "$tmpdir:/data" stain/bagit bag baginplace "$name"


tar="$name.bag.tar"
tar cfv "$tar" "$name"


# Go back to original current working directory
# to get correct relative paths
cd "$curdir"

dest="`dirname $1`/$tar"
mv "$tmpdir/$tar" "$dest"
rm -rf "$tmpdir"
echo Created "$dest"
