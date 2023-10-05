#!/bin/bash
echo "downloading saxon"
wget https://github.com/Saxonica/Saxon-HE/releases/download/SaxonHE11-6/SaxonHE11-6J.zip
unzip SaxonHE11-6J.zip -d saxon
rm -rf SaxonHE11-6J.zip