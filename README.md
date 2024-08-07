# EPUB for schnitzler-briefe

## GitHub-Action

The GitHub-Action "Create EPUB" fetches data from https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/tree/main/editions and transforms the XML files to XHTML.

With these XHTML files it produces an E-Book of all correspondences that have the status "approved".

## If working manually
Reproduce the workflow defined here: https://github.com/arthur-schnitzler/schnitzler-briefe-epub/blob/main/.github/workflows/epub.yaml

… means:

- Install Saxon by running
```
sh shellscripts/dl_saxon.sh
```
- Download/Pull edition files from https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/tree/main/editions and save them to a subdirectory named editions
- Remove unapproved files by running
```
python remove-unapproved-files.py
```
- Transform the edition files and rename the suffixes of the edition files to .xhtml by running
```
ant -f editions-to-epub.xml
```
- Remove empty namespace declarations by running
```
python remove-empty-namespace-declarations.py
```
- Remove files that were (for whatever reason) not transformed by running
```
python remove-tei-files.py
```
- Generate TOCs for the epub, means: transform OEBPS/content.opf, OEBPS/texts/inhalt.xhtml and OEBPS/texts/inhaltsverzeichnis.ncx by running
```
ant -f create-tocs.xml
```
- Create the EPUB by running
```
zip -rX out/schnitzler-briefe.epub mimetype META-INF/ OEBPS/ -x "*.DS_Store" -x "README.md" -x "epubcheck.jar" -x "lib" -x "out" -x "obsolete" -x "xslt" -x ".gitignore" -x ".git" -x ".github" -x "fetch-data.sh" -x "remove-unapproved-files.py" -x "remove-empty-namespace-declarations.py" -x "remove-tei-files.py" -x "requirements.txt" -x "shellscripts" -x "editions-to-epub.xml" -x "create-tocs.xml" -x "LICENSE"
```
- Optionally: Validate the EPUB by running
```
java -jar epubcheck.jar out/schnitzler-briefe.epub
```
- Commit and push
