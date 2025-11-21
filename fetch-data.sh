# bin/bash

# get schnitzler-briefe-data

rm -rf editions
wget https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit/archive/refs/heads/main.zip
unzip main.zip

mv schnitzler-briefe-arbeit-main/editions editions/
rm main.zip
rm -rf ./schnitzler-briefe-arbeit-main
