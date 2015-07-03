# Example of Research Object as a BagIt container

[BagIt](https://tools.ietf.org/html/draft-kunze-bagit-11) is an Internet Draft
that specifies a file system structure for transferring and archiving a
collection of files, including their checksums and brief metadata.

[Research Object bundles](https://w3id.org/bundle/) is a specification for
a structured ZIP-file, based on the ePub and Adobe UCF specifications.
The bundle serializes a [Research Object](http://www.researchobject.org/),
embedding some or all of its resources within the ZIP file, and
list the RO  content in a _manifest_, in addition to embedding and
referencing _annotations_ and _provenance_.

A BagIt bag can be considered a mechanism for serialization and transport
consistency, while a Research Object can be considered a way to capture
identity, annotations and provenance of the resources. As such, the two
formats complement each-other. They are however
[not directly compatible](#consideration)

This GitHub repository explains by example a profile a BagIt bag that is also
a Research Object. Feel free to
[provide comments and raise issues](https://github.com/ResearchObject/bagit-ro-ex1/issues),
or
[suggest changes as pull requests](https://github.com/ResearchObject/bagit-ro-ex1/pulls).



## Example overview

Overview of this example:

* [example1/](example1/) - the bag `example1`
  * [bagit.txt](example1/bagit.txt) - complies with BagIt version 0.97
  * [manifest-md5.txt](example1/manifest-md5.txt) - manifest, md5-sums of all of `data/`
  * [manifest-sha1.txt](example1/manifest-sha1.txt) - .. and sha1
  * [tagmanifest-md5.txt](example1/tagmanifest-md5.txt) - tag manifest, md5-sums of the remaining _tag files_
  * [tagmanifest-sha1.txt](example1/tagmanifest-sha1.txt) - .. and sha1
  * [fetch.txt](example1/fetch.txt) - external URLs to add to `data/`
  * [bag-info.txt](example1/bag-info.txt) - bag metadata such as size in bytes
  * [data/](example1/data/) - _payload_ directory - what this bag is primarily transferring
    * [README.md](example1/data/README.md) - Describes the payload, e.g. how to run script
    * [numbers.csv](example1/data/numbers.csv) - Raw data as CSV-file
    * [analyse.py](example1/data/analyse.py) - A script to analyze the CSV
    * [results.txt](example1/data/results.txt) - Output from script
  * [.ro/](example1/.ro/) - _tag directory_ for Research Object metadata
    * [manifest.json](example1/.ro/manifest.json) - RO [manifest](https://w3id.org/bundle#manifest) as JSON-LD
    * [annotations/](example1/.ro/annotations/) - structured annotations of RO and RO content, e.g. user-provided descriptions
      * [numbers.jsonld](example1/.ro/annotations/numbers.jsonld) - JSON-LD annotations, describing `data/numbers.csv`
    * [provenance/](example1/.ro/provenance/) - provenance of RO content
      * [result.prov.jsonld](example1/.ro/provenance/result.prov.jsonld) - Provenance of execution of `data/analyse.py`, which created `data/results.txt`


## BagIt overview

A [bag](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2)
in [BagIt](https://tools.ietf.org/html/draft-kunze-bagit-11) is a base
folder (in this example [example1/](example1/)) that contains the
[bagit declaration](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.1.1) in
[bagit.txt](example1/bagit.txt). A bag contains a _payload_, the data files
that are being transferred, in addition to _tag files_, metadata for the bag and
its content.

A [BagIt serialization](https://tools.ietf.org/html/draft-kunze-bagit-11#section-4)
is typically a tar- or zip-file which contains the base folder.
BagIt archives include at the root a subdirectory for the base folder of the
bag, e.g. the ZIP file would contain `example1/bagit.txt` etc.

The [payload](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.1.2)
of a bag is the files within a directory that
is always called [data](example1/data/). The `data` folder may
contain arbitrary files and subdirectories.

The payload files are listed in one or more
[manifest](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.1.3) files that
providing hashes of the file content. The BagIt specification specifies the
two most common hashing mechanisms _md5_ and _sha1_ to be represented by
[manifest-md5.txt](example1/manifest-md5.txt) and
[manifest-sha1.txt](example1/manifest-sha1.txt).

Files that are too big to practically include in a BagIt archive
can be [referenced externally](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.3)
in [fetch.txt](example1/fetch.txt), which includes the
URLs, expected file size and destination filenames within the bag base directory.

A bag can also contain
[other tag files](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.4),
which would be listed in a separate
[tag manifest](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.1),
e.g. [tagmanifest-md5.txt](tagmanifest-md5.txt) and
[tagmanifest-sha1.txt](tagmanifest-sha1.txt)

## Research Object overview

## Considerations
