#!/bin/bash
set -euo pipefail

# get schnitzler-briefe-data

rm -rf editions schnitzler-briefe-arbeit-main main.zip
wget -q -O main.zip https://github.com/arthur-schnitzler/schnitzler-briefe-arbeit/archive/refs/heads/main.zip
unzip -q main.zip
mv schnitzler-briefe-arbeit-main/editions editions
rm -rf main.zip schnitzler-briefe-arbeit-main
