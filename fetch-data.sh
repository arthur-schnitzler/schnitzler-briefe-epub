#!/bin/bash
set -euo pipefail

# get schnitzler-briefe-data

rm -rf editions schnitzler-briefe-arbeit-main main.zip
wget -q -O main.zip https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit/archive/refs/heads/main.zip
# nur editions/ entpacken: alles andere wird nicht gebraucht, und macOS-unzip
# scheitert an Dateinamen mit Umlauten in anderen Teilen des Archivs
unzip -q main.zip "schnitzler-briefe-arbeit-main/editions/*"
mv schnitzler-briefe-arbeit-main/editions editions
rm -rf main.zip schnitzler-briefe-arbeit-main
