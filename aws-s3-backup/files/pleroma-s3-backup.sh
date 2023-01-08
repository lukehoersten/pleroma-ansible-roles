#!/bin/bash

INSTANCE=$1

BUCKET="pleroma-${INSTANCE//_/-}-backup"
BACKUP_DIR="/tmp/s3-backup/$BUCKET"
BACKUP_TAR="/tmp/s3-backup/$BUCKET.tgz"

DB_NAME="pleroma_$INSTANCE"
CONFIG="/etc/pleroma/$INSTANCE.config.exs"

UPLOADS_DIR=`grep uploads $CONFIG | cut -d '"' -f 2`
STATIC_DIR=`grep static $CONFIG | cut -d '"' -f 2`

mkdir -m 775 -p "$BACKUP_DIR/"
chown root:postgres "$BACKUP_DIR/"

su postgres -c "pg_dump -d $DB_NAME --format=custom -f $BACKUP_DIR/$DB_NAME.pgdump"
cp $CONFIG "$BACKUP_DIR/"
cp -r $UPLOADS_DIR "$BACKUP_DIR/"
cp -r $STATIC_DIR "$BACKUP_DIR/"

tar -zc -f $BACKUP_TAR $BACKUP_DIR
aws s3 mb "s3://$BUCKET/"
aws s3api put-bucket-versioning --bucket "$BUCKET" --versioning-configuration Status=Enabled
aws s3api put-bucket-lifecycle-configuration --bucket "$BUCKET" --lifecycle-configuration "file:///usr/local/share/pleroma-s3-backup-lifecycle.json"
aws s3 cp $BACKUP_TAR "s3://$BUCKET/"

rm $BACKUP_TAR
rm -r $BACKUP_DIR
