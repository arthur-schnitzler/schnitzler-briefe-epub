# EPUB for schnitzler-briefe

## GitHub-Action

The GitHub-Action "Create EPUB" fetches data from https://github.com/arthur-schnitzler/schnitzler-briefe-data/tree/main/data/editions and transforms the XML files to XHTML.

With these XHTML files it produces an E-Book of all correspondences that have the status "approved".

## If working manually:

- Download edition files from https://github.com/arthur-schnitzler/schnitzler-briefe-data/tree/main/data/editions and save them to a subdirectory named editions
- Remove unapproved files by running in the epub directory:
```
python remove-unapproved-files.py
```
- Transform edition files with editions-to-xhtml-for-epub.xsl
- Rename the suffixes of the edition files to xhtml
- Remove empty namespace declarations by running in the epub directory:
```
python remove-empty-namespace-declarations.py
```
- Remove files that were not transformed by running in the epub directory:
```
python remove-tei-files.py
```
- Copy XHTML files to ./OEBPS/texts and remove the editions subdirectory
- Transform OEBPS/content.opf with create-content.xsl
- Transform OEBPS/texts/inhalt.xhtml with create-inhalt.xsl
- Transform OEBPS/texts/inhaltsverzeichnis.ncx with create-inhaltsverzeichnis.xsl
- Create the EPUB by running in the epub directory:
```
zip -rX out/schnitzler-briefe.epub mimetype META-INF/ OEBPS/ -x "*.DS_Store" -x "README.md" -x "epubcheck.jar" -x "lib" -x "out" -x "xslt" -x ".git" -x ".github" -x "fetch-data.sh" -x "remove-unapproved-files.py" -x "remove-empty-namespace-declarations.py" -x "remove-tei-files.py" -x "requirements.txt" -x "shellscripts" -x "editions-to-epub.xml" -x "create-tocs.xml" -x "LICENSE"
```
- Validate the EPUB by running in the epub directory:
```
java -jar epubcheck.jar out/schnitzler-briefe.epub
```
- Commit and push