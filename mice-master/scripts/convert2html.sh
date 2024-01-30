#!/usr/bin/env bash
source envsetup.sh
mkdir artifacts/html
cd artifacts/notebooks || exit 255

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function convert_notebook() {
    (
    echo "Converting $1"
    fname=$(basename $1)
    # run notebook
    jupyter nbconvert --to html \
    --output "../html/${fname}.html" \
    "$1" || {  printf "${RED}====> FAILED:${NC} $1\n" ; exit 99 ; }
    )
}

if [ $# -eq 1 ]; then
    process_notebook "$1"
else
    notebookcount=0
    while read -d $'\0' path ; do
        # if the noci flag was passed, dont look for a noci file
        if [[ -f "${path%/*}/noci" ]] ; then
            echo "===> noci found for ${path##*/}. skipping it."
            continue
        fi
        convert_notebook "$path"
        let notebookcount=notebookcount+1
    done < <(find . -name \*.ipynb -print0)
    echo The notebook count is "$notebookcount"
fi