#!/usr/bin/env bash

# ensure first param is a directory
test -d "$1" && thisdir=$1 || { echo "Argument 1: '$1' is not a directory" 1>&2 ; exit 1; }

# default repo
[[ -e $3 ]] && REPO=$3 || REPO='/V1/zbackuprepo'

# ensure and echo the incremental directory
[[ -e "$2" ]] && DATEDIR=$2 || DATEDIR=$REPO/backups/`date "+%Y%m%d_%H:%M"`
mkdir -p $DATEDIR
echo "$DATEDIR"

[[ -e $thisdir/.backupignore ]] &&  EXCLUDE="--exclude-from=$thisdir/.backupignore" ||  EXCLUDE=''
echo "sudo tar $EXCLUDE -vc $thisdir | zbackup --non-encrypted --silent backup $DATEDIR/$thisdir.zbtar"
sudo tar $EXCLUDE -vc $thisdir | zbackup --non-encrypted --silent backup $DATEDIR/$thisdir.zbtar
