#!/usr/bin/env bash
source envsetup.sh
mkdir artifacts/pdf
cd artifacts/html || exit 255
while read -d $'\0' path; do
  fname=$(basename $path)
  google-chrome --no-sandbox --headless --run-all-compositor-stages-before-draw --virtual-time-budget=10000000 --print-to-pdf="../pdf/$fname.pdf" "$path"
done < <(find . -name \*.html -print0)
