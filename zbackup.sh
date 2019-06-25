#!/usr/bin/env bash

# refs:
# https://www.linuxjournal.com/content/ideal-backups-zbackup
#
# meant to be run from the project root directory
# with zbackuprepo either passed as a param or defaulting to:
[[ -e $1 ]] && export REPO=$1 || export REPO='/V1/zbackuprepo'
echo "Using Repo: $REPO";

# if there is a zbackup info file skip init
[[ -e "$REPO/info" ]] && echo 'already initialized' || mkdir --mode=u+rwx,g+rws,o-rwx -p $REPO && zbackup init --non-encrypted $REPO && chmod 775 $REPO/backups

# make and echo the new incremental directory
export DATEDIR=$REPO/backups/`date "+%Y%m%d_%H:%M"`
mkdir -p $DATEDIR
echo "$DATEDIR"

# find all subdirectories | clean to basename | exclude . | loop
find .  -maxdepth 1 -type d | xargs -i basename {} | grep -v '\.' |  while read -r eachdir ; do
    echo "Processing $eachdir"
    # check for a .backupignore file and pass it to tar if found
    [[ -e $eachdir/.backupignore ]] && export EXCLUDE="--exclude-from=$eachdir/.backupignore" || export EXCLUDE=''
    echo "sudo tar $EXCLUDE -vc $eachdir | zbackup --non-encrypted --silent backup $DATEDIR/$eachdir.zbtar"
    sudo tar $EXCLUDE -vc $eachdir | zbackup --non-encrypted --silent backup $DATEDIR/$eachdir.zbtar
done
