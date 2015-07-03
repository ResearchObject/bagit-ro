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
formats complement each-other.

This GitHub repository contains an example of how a BagIt bag can also be a
Research Object. Feel free to
[provide comments and raise issues](https://github.com/ResearchObject/bagit-ro-ex1/issues),
or
[suggest changes as pull requests](https://github.com/ResearchObject/bagit-ro-ex1/pulls).



## Example overview

Overview of this example:

* [example1/](example1/) - the bag `example1`
  * [bagit.txt](example1/bagit.txt) - complies with BagIt version 0.97
  * [manifest-md5.txt](example1/manifest-md5.txt) - manifest, md5-sums of all of `data/`
  * [manifest-sha1.txt](example1/manifest-sha1.txt) - .. and sha1
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

A _bag_ in [BagIt](https://tools.ietf.org/html/draft-kunze-bagit-11) is a base
folder (in this example [example1/](example1/)) that contains the file
[bagit.txt](example1/bagit.txt) to identify the folder as a bag, and
declare the version of the specification that is used.

A [BagIt serialization](https://tools.ietf.org/html/draft-kunze-bagit-11#section-4)
is typically a tar- or zip-file which contains the base folder.
BagIt archives include at the root a subdirectory for the base folder of the
bag, e.g. the ZIP file would contain `example1/bagit.txt` etc.

The _payload_ of a bag is the files within a directory that
is always called [data](example1/data/). The `data` folder may
contain artbitrary files and subdirectories.

The payload files are listed in one or more _manifest_ files that
providing hashes of the file content. The BagIt specification specifies the
two most common hashing mechanisms _md5_ and _sha1_, represented by
[manifest-md5.txt](example1/manifest-md5.txt) and
[manifest-sha1.txt](example1/manifest-sha1.txt).

Payload files that are too big to practically include in a BagIt archive
can be referenced externally in [fetch.txt](example1/fetch.txt)

## Research Object overview
