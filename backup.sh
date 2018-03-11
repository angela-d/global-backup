#!/bin/bash

#configure stuff
USER="your_db_user"
PASSWORD="your_db_password"
PROD_BAK_DIR="/var/www/bak.your_dev_folder"
DATE="`date +%m-%d-%y-%s`"
OUTPUT="/var/backup/databases"
WS_OUTPUT="/var/backup/websites/"
BACKUP_OUTPUT="$DATE-www.tar"
SITES_BACKUP="/var/www"

#backup & zip all databases
databases=`mysql --user=$USER --password=$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database`

for db in $databases; do
    if [[ "$db" != "information_schema" ]] && [[ "$db" != _* ]] ; then
        echo "Dumping database: $db"
        mysqldump --force --opt --user=$USER --password=$PASSWORD --databases --skip-lock-tables $db > $OUTPUT/$DATE.$db.sql
        gzip $OUTPUT/$DATE.$db.sql
    fi
done

	#sweep outdated backups
	echo "Sweeping out-of-date backups in $OUTPUT.."
	/usr/bin/find $OUTPUT/* -mtime +5 -exec rm {} \;

	#get rid of old bak file
	if [ -d "$PROD_BAK_DIR" ]; then rm -Rf $PROD_BAK_DIR; fi

	#backup www folder
	echo "Creating a tar of $BACKUP_OUTPUT for $SITES_BACKUP.."
	tar --exclude='/var/www/exclude_dir' --exclude='/var/www/exclude_dir1' -cpvf $BACKUP_OUTPUT $SITES_BACKUP

	#gzip compress
	echo "gzip compress of $BACKUP_OUTPUT.."
	gzip -9fv $BACKUP_OUTPUT

	#move to backup directory
	mv $BACKUP_OUTPUT.gz $WS_OUTPUT

	#sweep outdated backups
	echo "Sweeping out-of-date backups in /var/backup/websites.."
	/usr/bin/find $WS_OUTPUT* -mtime +5 -exec rm {} \;

echo "DONE!"
