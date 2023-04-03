#!/bin/bash

set -e
folders=("frontend" "backend")

for folder in ${folders[@]}; do
  cd $folder
  bash test.sh
  cd ..
done