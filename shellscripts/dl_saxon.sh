#!/bin/bash
set -euo pipefail
echo "downloading saxon"
wget -q -O SaxonHE11-6J.zip https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE11-6/SaxonHE11-6J.zip
unzip -o -q SaxonHE11-6J.zip -d saxon
rm -f SaxonHE11-6J.zip
