# bin/bash

# get schnitzler-briefe-data

rm -rf editions
wget https://github.com/arthur-schnitzler/arthur-schnitzler-arbeit/archive/refs/heads/main.zip
unzip main.zip

mv arthur-schnitzler-arbeit-main/editions editions/
rm main.zip
rm -rf ./arthur-schnitzler-arbeit-main
