#!/bin/bash

BACKUP_NAME="emacs"

BACKUP_DIR="$HOME/.backups/$BACKUP_NAME"
# 2009-06-22-233959
DATE=`date +%Y-%m-%d-%H%M%S`

BACKUP_FILELIST="$BACKUP_DIR/`whoami`-$BACKUP_NAME-$DATE.lst"
BACKUP_FILE="$BACKUP_DIR/`whoami`-$BACKUP_NAME-$DATE.tgz"

if [ ! -e "$BACKUP_DIR" ]; then    # Check Backup Directory exists.
  mkdir -p "$BACKUP_DIR"
fi

cat >$BACKUP_FILELIST <<EOF
$HOME/.emacs
$HOME/.emacs.d/
EOF

cecho.sh g "========================================"
cat $BACKUP_FILELIST
tar -cpzPf $BACKUP_FILE -T $BACKUP_FILELIST
cecho.sh g "have been compressed into $BACKUP_FILE."

# send

BACKUP_EMAIL="lotreal+bu@gmail.com"

cecho.sh y "Send to $BACKUP_EMAIL..."

printf "== lot's $BACKUP_NAME backup file list ==

`tar -tzPf $BACKUP_FILE`" | mutt -s "lot's $BACKUP_NAME Backup (${DATE})" -a $BACKUP_FILE $BACKUP_EMAIL
cecho.sh g "Done!, It's Sent!"
echo ""