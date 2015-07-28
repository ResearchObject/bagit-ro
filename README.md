# Research Object BagIt archive

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
[not directly compatible](#considerations).

This GitHub repository explains by example a profile for a BagIt bag to also be
a Research Object. Feel free to
[provide comments and raise issues](https://github.com/ResearchObject/bagit-ro-ex1/issues),
or
[suggest changes as pull requests](https://github.com/ResearchObject/bagit-ro-ex1/pulls).

Run the `build.sh` script (requires `zip`, `md5sum`, `sha1sum`, `find`) to
generate `example1.bagit.zip` and the corresponding `example1.bundle.zip`.


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
      * [result.prov.jsonld](example1/.ro/provenance/results.prov.jsonld) - Provenance of execution of `data/analyse.py`, which created `data/results.txt`


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
bag, e.g. the ZIP file would contain `example1/bagit.txt`.

The [payload](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.1.2)
of a bag is the files within a directory that
is always called [data](example1/data/). The `data` folder may
contain arbitrary files and subdirectories. In this example we include a
simple [CSV data file](example1/data/numbers.csv), an
analytical [script](example1/data/analyse.py), and
the [results](example1/data/results.txt) of running that script. In addition,
a textual [README.md](example1/data/README.md) is included to describe this
execution.

The payload files are listed in one or more
[manifest](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.1.3) files
that provide hashes of the file content. The BagIt specification specifies the
two most common hashing mechanisms _md5_ and _sha1_ to be represented by
[manifest-md5.txt](example1/manifest-md5.txt) and
[manifest-sha1.txt](example1/manifest-sha1.txt). Other hash mechanisms
can also be added (e.g. sha512), but the content of any `manifest-*` file
need to follow the `$hash $filename` pattern.

Files that are too big to practically include in a BagIt archive
can be
[referenced externally](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.3)
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
[other tag files](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.4),
which would be listed in a separate
[tag manifest](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.1),
e.g. [tagmanifest-md5.txt](example1/tagmanifest-md5.txt) and
[tagmanifest-sha1.txt](example1/tagmanifest-sha1.txt). In this example, the tag manifest
lists the content of the [.ro](example1/.ro/) directory.
It is undefined in the BagIt specification if the remaining tag files
(e.g. `bag-info.txt` or `fetch.txt`) should be included in the tag manifest,
this example assumes they should *not* be included.

## Research Object overview

A [Research Object](http://www.researchobject.org/) (RO) is conceptually an
aggregation of related resources, an assignment of their identities, and
any relevant annotations and provenance statements. The
[Research Object model](https://w3id.org/ro/) specifies how to
declare these relations, combining existing _Linked Data_ standard like
[OAI-ORE](http://www.openarchives.org/ore/1.0/toc),
[W3C Annotation Data Model](http://www.w3.org/TR/annotation-model/)
and [W3C PROV](http://www.w3.org/TR/prov-o/).

Serialized as a
[Research Object Bundle](https://w3id.org/bundle/), some or all of those
resources are included in the encapsulating ZIP archive together
with a [JSON-LD](http://json-ld.org/) manifest,
[.ro/manifest.json](example1/.ro/manifest.json).

A Research Object BagIt archive follows the same structure as an Research Object
Bundle, except that the base directory is the bag base (e.g. `example1/`),
rather than the root folder of the ZIP archive (`/`).

The [aggregates](example1/.ro/manifest.json#L10) section of the manifest
list the payload files, both embedded (e.g. `../data/numbers.csv`) and
[external resources](example1/.ro/manifest.json#L9) (e.g. `http://example.com/doc1`).
Note that local paths are under `../data/`, relative to the `.ro/` folder.

This `aggregates` listing provides hooks for additional metadata and
provenance, e.g.
[mediatype](example1/.ro/manifest.json#L13),
[authoredBy](example1/.ro/manifest.json#L22) and
[retrievedFrom](example1/.ro/manifest.json#L31).
A file can claim to conform to a standard,
minimum information checklist, requirements or
similar using [conformsTo](example1/.ro/manifest.json#L30).

If more detailed provenance is available, then
[history](example1/.ro/manifest.json#L17) can link to a
separate provenance trace, e.g. a
[PROV-O RDF file](example1/.ro/provenance/results.prov.jsonld), although any kind of
embedded or external provenance resource could be
appropriate (e.g. log file, word document, git repository). Provenance can
also be included for the [research object itself](example1/.ro/manifest.json#L3).

Annotations about any of the resources in the bag (or the RO itself)
can be linked to from the [annotations](example1/.ro/manifest.json#L49)
section. Here `about` specifies one or more resources that are annotated,
while `content` links to the annotation content, which could be any aggregated
or external resource (e.g [../data/README.md](example1/data/README.md) that
describes `analyse.py`, `numbers.csv` and `results.txt`), or a
metadata file under `.ro/annotations/`, typically in a Linked Data format.
In this example,
[annotations/numbers.jsonld](example1/.ro/annotations/numbers.jsonld)
provide semantic annotations of [../data/numbers.csv](example1/data/numbers.csv)
in JSON-LD format.

It is customary in Research Object Bundles for non-payload files to not be
listed under `aggregates` and to be stored under `.ro/`. In Research Object
BagIt archives follow this convention, in addition the payload files
must exclusively be within the `data/` folder (or be external URLs).
The `.ro` content is listed in the
[tag manifest](example1/tagmanifest-md5.txt), while the
payload is listed under in the [payload manifest](example1/manifest-md5.txt)
with external URLs in the [fetch file](example1/fetch.txt).


## Considerations

The combination of BagIt and Research Object adds:

* RO consistency with checksums for payload and metadata
* Structured metadata, provenande and annotations for the bag and its content
  * With extensions in JSON-LD using any Linked Data vocabulary
* Graceful degradation/conversion to plain BagIt or RO Bundle

A RO Bundle is fundamentally not very different from an archived
BagIt bag, except that in the RO Bundle, the `.ro/` is in the root
directory together with a marker `mimetype` file to help _mime magic_-like tools
identify the file type.

[BagIt serialization](https://tools.ietf.org/html/draft-kunze-bagit-11#section-4)
mandates that a BagIt archive contains only a single directory when unpacked,
which is the base directory of the bag. While in theory a hybrid RO Bundle and
BagIt ZIP archive could exist, it would have to use the bag name `.ro` and
could not include the `mimetype` file without a hack. In addition the
payload would then be contained in `.ro/data/`, which is not what you would
expect from the RO Bundle specification.

The approach shown here is a variation of RO Bundle which contains the
Research Object within the bag of an arbitrary name, thus the RO manifest in a
Research Object BagIt archive is in this example at
[example1/.ro/manifest.json/](example1/.ro/manifest.json) rather than
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
alternative approach to move `/.ro/manifest.json` to `/manifest.json`
could improve on this, but would mean the manifest would no longer be
directly usable also as an RO Bundle manifest.

The [build.sh](build.sh#L22) script shows how this structure mean that a
Research Object BagIt archive can be converted to a Research Object Bundle
by adding the `mimetype` file and simply archiving from within the bag directory.

A similar conversion from RO Bundle to Research Object BagIt would require
moving its embedded resources to `data/` and rewrite the local paths in its
manifest and annotations.

Having two kinds of manifests (`.ro/manifest.json` and `.ro/manifest.json`)
can be confusing, and can lead to inconsistency if a tool supporting only
one of these kind is modifying an RO BagIt.  

The `bag-info.txt` format supports some
[basic bag-level metadata](https://tools.ietf.org/html/draft-kunze-bagit-11#section-2.2.2), e.g.
`Bagging-Date`, `Contact-Phone` and `Organization-Address`. While some of these
might seem archaic, "other arbitrary metadata elements may also be present.",
allowing extensions. 

Research Object BagIt archives SHOULD specify the bagit-ro [BagIt profile](https://github.com/ruebot/bagit-profiles):

```
    BagIt-Profile-Identifier: https://rawgit.com/ResearchObject/bagit-ro-ex1/master/profile.json
```

**FIXME:** Permanent URI for the bagit-ro profile


The BagIt specification has no requirements for such alternative elements
(e.g.  they are not [RFC 2822](https://tools.ietf.org/html/rfc2822) headers),
and it is unclear if any whitespace
(e.g. newlines and indentation) form part of the BagIt values or not.

An alternative approach to dual manifests could therefore be to
structure the RO Manifest within `bag-info.txt`, e.g.
with the complete `.ro/manifest.json` structure under a
[Research-Object](https://gist.github.com/stain/cc1046ad861b11bf3ba6#file-bag-info-txt-L14) key,
which would still duplicate (and get out of sync) the list of paths under `aggregates`, and would
require careful JSON parsing and writing to ensure the JSON is correctly
interpreted as a single BagIt element value.
The value of this is mainly for manual BagIt consumption, as BagIt tools would
not recognize the need to update the `Research-Object` element. This would
however come at a cost of being harder to read/write the JSON-LD manifest,
and would not preserve the immediate interoperability with RO Bundles.

An approach of split out of [multiple `RO-*`` keys](https://gist.github.com/stain/23080e58158a62533052)
is not particularly promising, even if it would get rid of the `aggregates`
duplication.  The difficulty here is that `bag-info.txt` is not
hierarchical, and so per-file provenande and annotations are hard
to structure without defining a mini-syntax per field with clear
escape rules (e.g. catering for filenames with spaces). It would also no
longer be possible to extend the manifest with custom vocabularies.
