#!/bin/bash

set -e ; set -u

mkdir -p artifacts
mkdir -p artifacts/notebooks

NOTEBOOKS_EXCLUDE=(" ")
DATASETS=(https://cloud.p01ar.net/index.php/s/PGiQM5HEGDDGbpX/download/22ht1.csv https://cloud.p01ar.net/index.php/s/Fk4232J5T7HEYB8/download/22ht3.csv)

source envsetup.sh

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

mkdir -p out

echo "${GREEN}===>${NC} Downloading data"
mkdir -p data
cd data/
for url in "${DATASETS[@]}"; do
  wget --no-verbose "$url"
done
cd ..
echo "${GREEN}===>${NC} Download complete"

function convert_notebook() {
    (
    echo "Executing $1..."
    fname=$(basename $1)
    date=$(date '+%Y-%m-%d-%H-%M-%S')
    # run notebook
    jupyter nbconvert --to notebook --execute \
    --ExecutePreprocessor.timeout=5000 \
    --output "$(pwd)/artifacts/notebooks/output-$fname-$date.ipynb" \
    "$1" || {  printf "${RED}====> FAILED:${NC} $1\n" ; exit 99 ; }
    )
}

if [ $# -eq 1 ]; then
    convert_notebook "$1"
else
    notebookcount=0
    while read -d $'\0' path ; do
        # if the noci flag was passed, dont look for a noci file
        if [[ -f "${path%/*}/noci" ]] ; then
            echo "===> noci found for ${path##*/}. skipping it."
            continue
        fi
        if [[ "$path" =~ "$NOTEBOOKS_EXCLUDE" ]]; then
          echo "===> $path is excluded. skipping it."
          continue
        fi
        convert_notebook "$path"
        echo "${GREEN}===>${NC} $path executed successfully"
        let notebookcount=notebookcount+1
    done < <(find . -name \*.ipynb -print0)
    echo The notebook count is "$notebookcount"
fi

mv out artifacts