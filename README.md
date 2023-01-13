# Research Object BagIt archive

* Document identifier: https://w3id.org/ro/bagit
* Author: Stian Soiland-Reyes http://orcid.org/0000-0001-9842-9718

[BagIt](https://tools.ietf.org/html/draft-kunze-bagit-14) is an Internet Draft
that specifies a file system structure for transferring and archiving a
collection of files, including their checksums and brief metadata.

[RO-Crate](https://w3id.org/ro/crate/) is a specification for formalizing a [Research Object](http://www.researchobject.org/)
using a _RO-Crate Metadata File_ `ro-crate-metadata.json`. 

(Note: A [previous version]() of this profile supported [Research Object bundles](https://w3id.org/bundle/) instead of RO-Crate)

A BagIt bag can be considered a mechanism for serialization and transport
consistency, while a Research Object can be considered a way to capture
identity, annotations and provenance of the resources. As such, the two
formats complement each-other. They are however
[not directly compatible](#considerations).

This GitHub repository explains by example a
[profile](profile.json) for a BagIt bag to also be
a Research Object. Feel free to
[provide comments and raise issues](https://github.com/ResearchObject/bagit-ro/issues),
or
[suggest changes as pull requests](https://github.com/ResearchObject/bagit-ro/pulls).

Run the `build.sh` script (requires `zip`, `md5sum`, `sha1sum`, `find`) to
generate `example1.bagit.zip` and the corresponding `example1.bundle.zip`.


## Example overview

Overview of this example:

* [example1/](example1/) - the bag `example1`
  * [bagit.txt](example1/bagit.txt) - complies with BagIt version 1.0
  * [bag-info.txt](example1/bag-info.txt) - bag metadata such as size in bytes
  * [manifest-sha512.txt](example1/manifest-sha512.txt) - .. and sha1
  * [tagmanifest-sha512.txt](example1/tagmanifest-sha512.txt) - tag manifest, md5-sums of the
  * [fetch.txt](example1/fetch.txt) - external URLs to add to `data/`
  * [data/](example1/data/) - _payload_ directory - what this bag is primarily transferring
    * [README.md](example1/data/README.md) - Describes the payload, e.g. how to run script
    * [numbers.csv](example1/data/numbers.csv) - Raw data as CSV-file
    * [analyse.py](example1/data/analyse.py) - A script to analyze the CSV
    * [results.txt](example1/data/results.txt) - Output from script
    * [ro-crate-metadata.json](example1/data/ro-crate-metadata) - [RO-Crate](https://w3id.org/ro/crate/) metadata file as JSON-LD


## BagIt overview

A [bag](https://www.rfc-editor.org/rfc/rfc8493.html#section-2)
in [BagIt](https://www.rfc-editor.org/rfc/rfc8493.html) (RFC8493) is a base
folder (in this example [example1/](example1/)) that contains the
[bagit declaration](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.1.1) in
[bagit.txt](example1/bagit.txt). A bag contains a _payload_, the data files
that are being transferred, in addition to _tag files_, any additional 
metadata for the bag and its content.

A [BagIt serialization](https://tools.ietf.org/html/draft-kunze-bagit-14#section-4)
is typically a tar- or zip-file which contains the base folder.
BagIt archives include at the root a subdirectory for the base folder of the
bag, e.g. the ZIP file would contain `example1/bagit.txt`.

The [payload](https://tools.ietf.org/html/draft-kunze-bagit-14#section-2.1.2)
of a bag is the files within a directory that
is always called [data](example1/data/). The `data` folder may
contain arbitrary files and subdirectories. In this example we include a
simple [CSV data file](example1/data/numbers.csv), an
analytical [script](example1/data/analyse.py), and
the [results](example1/data/results.txt) of running that script. In addition,
a textual [README.md](example1/data/README.md) is included to describe this
execution.

The payload files are listed in one or more
[manifest](https://tools.ietf.org/html/draft-kunze-bagit-14#section-2.1.3) files
that provide hashes of the file content. The BagIt specification specifies the
two most common hashing mechanisms _md5_ and _sha1_ to be represented by
[manifest-md5.txt](example1/manifest-md5.txt) and
[manifest-sha1.txt](example1/manifest-sha1.txt). Other hash mechanisms
can also be added (e.g. sha512), but the content of any `manifest-*` file
need to follow the `$hash $filename` pattern.

Files that are too big to practically include in a BagIt archive
can be
[referenced externally](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.3)
in [fetch.txt](example1/fetch.txt), which includes the
URLs to download, expected file size and destination filenames
within the bag base directory.
It is undefined in the BagIt specification which `Accept*` headers should be
used in such a retrieval, or if any authentication might be required. This
example do not need to make any assumption for this as the
referenced [external.txt](https://gist.githubusercontent.com/anonymous/7fe620279ea4988a5a1e/raw/e55d9ea6af35ea67cfaf47b03a2b71f9026325fd/external.txt)
is only available in a single representation. It is undefined in the BagIt
specification if the resources in `fetch.txt` should be considered when
creating `manifest-*` and in `Payload-Oxum`, this
example assumes they should *not* be included. It is undefined in the BagIt
specification what is the expected interpretation if a file in `fetch.txt`
already exists in the bag's `data` directory.

A bag can also contain
[other tag files](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.4),
which would be listed in a separate
[tag manifest](https://www.rfc-editor.org/rfc/rfc8493.html#section-2.2.1),
e.g. [tagmanifest-sha512.txt](example1/tagmanifest-sha512.txt). 
This example has no other tag files (`ro-crate-metadata.json` is considered part of the payload), 
thus the tag manifest lists only checksums of the other root tag files, e.g. `manifest-sha256.txt`.

## Research Object overview

A [Research Object](http://www.researchobject.org/) (RO) is conceptually an
aggregation of related resources, an assignment of their identities, and
any relevant annotations and provenance statements. 

[RO-Crate](https://w3id.org/ro/crate) specifies how to write down an RO as a
collection as files and references, described in an 
_RO-Crate Metadata File_. The file uses primarily 
[schema.org](https://schema.org/) annotations using [JSON-LD](https://json-ld.org/).

RO-Crates can be stored and published in many ways, but can be identified by the presence of the RO-Crate Metadata File with the fixed filename `ro-crate-metadata.json`. 

The RO-Crate specification suggests how to [add RO-Crate to BagIt](https://www.researchobject.org/ro-crate/1.1/appendix/implementation-notes.html#adding-ro-crate-to-bagit). This profile gives 


Research Object BagIt archives SHOULD specify the [BagIt profile](https://github.com/ruebot/bagit-profiles)
for bagit-ro within `bag-info.txt` as:

```
BagIt-Profile-Identifier: https://w3id.org/ro/bagit/profile
```

## Considerations

The combination of BagIt and Research Object adds:

* RO consistency with checksums for payload and metadata
* Structured metadata, provenance and annotations for the bag and its content
  * With extensions in JSON-LD using any Linked Data vocabulary
* Graceful degradation/conversion to plain BagIt or RO Bundle

A RO-Crate is fundamentally not very different from an archived
BagIt bag, but `TODO`.

[BagIt serialization](https://tools.ietf.org/html/draft-kunze-bagit-14#section-4)
mandates that a BagIt archive contains only a single directory when unpacked,
which is the base directory of the bag. While in theory a hybrid RO Bundle and
BagIt ZIP archive could exist, it would have to use the bag name `.ro` and
could not include the `mimetype` file (without a binary zip file hack).
In addition the payload would then be contained in `.ro/data/`,
which is not what you would expect from the RO Bundle specification
and which would hide all content from Unix/Linux users.

The approach shown here is therefore a variation of RO Bundle which contains the
Research Object within the bag of an arbitrary name, thus the RO manifest in a
Research Object BagIt archive is in this example at
[example1/metadata/manifest.json/](example1/metadata/manifest.json) rather than
`.ro/manifest.json`.

The interpretation of `manifest.json` according to the
[RO Bundle specification](https://w3id.org/bundle/#manifest-json)
assumes `/` is the root of the ZIP file, to also be the root of the RO.

A BagIt bag is not necessarily rooted within an
archive, and could be living standalone within a file system directory,
or be exposed on the Web at an arbitrary URL base. The name of the containing
bag is not declared outside its directory name. The RO manifest and annotations
in this approach therefore uses only relative URI paths, e.g.
`../data/analyse.py`, while the RO Bundle
manifest would have used `/data/analyse.py`.

Developers can struggle to generate correct relative paths. An
alternative approach to move `/metadata/manifest.json` to `/manifest.json`
could improve on this, but would mean the manifest would no longer be
easily usable also as an RO Bundle manifest as its relative paths
would differ.

The [build.sh](build.sh#L22) script shows how this structure mean that a
Research Object BagIt archive can be converted to a Research Object Bundle
by adding the `mimetype` file and simply archiving from within the bag directory.

A similar conversion from RO Bundle to Research Object BagIt would require
moving its embedded resources to `data/` and rewrite the local paths in its
manifest and annotations. See [bundle-to-bagit.sh](bundle-to-bagit.sh) for an example.

Having two kinds of manifests (`manifest-sha1.txt` and `metadata/manifest.json`)
can be confusing, and can lead to inconsistency if a tool supporting only
one of these kind is modifying an RO BagIt.  

The `bag-info.txt` format supports some
[basic bag-level metadata](https://tools.ietf.org/html/draft-kunze-bagit-14#section-2.2.2), e.g.
`Bagging-Date`, `Contact-Phone` and `Organization-Address`. While some of these
might seem archaic, "other arbitrary metadata elements may also be present.",
allowing extensions.

The BagIt specification has no requirements for such alternative elements
(e.g.  they are not [RFC 2822](https://tools.ietf.org/html/rfc2822) headers),
and it is unclear if any whitespace
(e.g. newlines and indentation) form part of the BagIt values or not.

It is recommended that only the basic metadata is provided in `bag-info.txt`,
while more structured metadata and provenance should be
provided in the Research Object manifest or annotations.
