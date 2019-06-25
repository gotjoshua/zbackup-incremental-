#!/usr/bin/env bash

# refs:
# https://www.linuxjournal.com/content/ideal-backups-zbackup
#
# meant to be run from the project root directory
# with zbackuprepo and app as sudirectories
[[ -e $1 ]] && export REPO=$1 || export REPO='/V1/zbackuprepo'
echo "Using Repo: $REPO";
[[ -e "$REPO/info" ]] && echo 'already initialized' || mkdir --mode=u+rwx,g+rws,o-rwx -p $REPO && zbackup init --non-encrypted $REPO && chmod 775 $REPO/backups
export DATEDIR=$REPO/backups/`date "+%Y%m%d_%H:%M"`
mkdir -p $DATEDIR
echo "$DATEDIR"

find .  -maxdepth 1 -type d | xargs -i basename {} | grep -v '\.' |  while read -r eachdir ; do
    echo "Processing $eachdir"
    [[ -e $eachdir/.backupignore ]] && export EXCLUDE="--exclude-from=$eachdir/.backupignore" || export EXCLUDE=''
    echo "sudo tar $EXCLUDE -vc $eachdir | zbackup --non-encrypted --silent backup $DATEDIR/$eachdir.zbtar"
    sudo tar $EXCLUDE -vc $eachdir | zbackup --non-encrypted --silent backup $DATEDIR/$eachdir.zbtar
done


# tar --exclude='app/.git' --exclude='app/node_modules' -vc ./app | zbackup --non-encrypted --silent backup ./zbackuprepo/backups/$DATEDIR/app.zbtar
