# EPUB for schnitzler-briefe

## GitHub-Action

The GitHub-Action "Create Epub" fetches data from https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit/tree/main/editions and transforms the XML files to XHTML.

With these XHTML files it produces an E-Book of all correspondences that have the status "approved", as well as a separate E-Book for each correspondence (identified via `tei:correspContext/tei:ref[@type='belongsToCorrespondence']`).

The finished EPUBs are published as GitHub release `latest`:
https://github.com/arthur-schnitzler/schnitzler-briefe-epub/releases/tag/latest

## If working manually

Reproduce the workflow defined here: https://github.com/arthur-schnitzler/schnitzler-briefe-epub/blob/main/.github/workflows/epub.yaml

… means:

- Saxon XSLT processor is included in the repository (directory `saxon/`) and ready to use. If needed, it can be re-downloaded by running:
```
sh shellscripts/dl_saxon.sh
```
- Download the edition files from https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit (saved to a subdirectory named `editions`) by running
```
./fetch-data.sh
```
- Remove unapproved files by running
```
python3 remove-unapproved-files.py
```
- Extract the mapping of letters to correspondences (needed later for the per-correspondence EPUBs; must run while the `editions` directory still exists) by running
```
python3 extract-correspondences.py
```
- Transform the edition files and rename the suffixes of the edition files to .xhtml by running (this also removes outdated XHTML files from `OEBPS/texts` and deletes the `editions` directory)
```
ant -f editions-to-epub.xml
```
- Remove empty namespace declarations by running
```
python3 remove-empty-namespace-declarations.py
```
- Remove files that were (for whatever reason) not transformed by running
```
python3 remove-tei-files.py
```
- Redirect links whose targets are not part of the EPUB (other edition parts, diary dates, PMB entities, unpublished letters) to the online edition by running
```
python3 fix-internal-links.py
```
- Generate TOCs for the epub, means: transform OEBPS/content.opf, OEBPS/texts/inhalt.xhtml and OEBPS/inhaltsverzeichnis.ncx by running
```
ant -f create-tocs.xml
```
- Create the EPUB by running (the `mimetype` entry must be the first entry of the archive and stored uncompressed, hence the two zip calls)
```
mkdir -p out
rm -f out/schnitzler-briefe.epub
zip -X0 out/schnitzler-briefe.epub mimetype
zip -rX9 out/schnitzler-briefe.epub META-INF/ OEBPS/ -x "*.DS_Store"
```
- Create one EPUB per correspondence in `out/korrespondenzen/` by running
```
python3 create-correspondence-epubs.py
```
- Optionally: Validate the EPUBs by running
```
java -jar epubcheck.jar out/schnitzler-briefe.epub
```
- Commit and push (note: the EPUBs in `out/` are not committed; the GitHub-Action publishes them as release assets)
