# bin/bash

# get schnitzler-briefe-data

rm -rf editions
wget https://github.com/arthur-schnitzler/schnitzler-briefe-data/archive/refs/heads/main.zip
rm -rf editions
unzip main.zip

mv schnitzler-briefe-data-main/data/editions editions/
rm main.zip
rm -rf ./schnitzler-briefe-data-main
