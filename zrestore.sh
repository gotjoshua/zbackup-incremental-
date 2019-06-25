#!/usr/bin/env bash
[[ -e $1 ]] && export REPO=$1 || export REPO='/V1/zbackuprepo'
PS3='Please choose a date: '
options=(`ls $REPO/backups`)
select opt in "${options[@]}"
do

  DATEDIR=(`ls $REPO/backups/$opt`)
  PS3='Please choose an archive: '
  select ARCHIVE in "${DATEDIR[@]}"
  do
    echo "$ARCHIVE"

    RESTORETO="/srv/${ARCHIVE%.*}"
    echo "first backing up $RESTORETO"
    echo "sudo zbackup --cache-size 1024mb --non-encrypted --silent restore $REPO/backups/$opt/$ARCHIVE  | sudo tar --overwrite -vx"

    break
  done
  break
done
