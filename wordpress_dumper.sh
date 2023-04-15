#!/bin/bash

# Variables
DATE=`date +%Y-%m-%d_%H-%M-%S`
BACKUP_DIR=/opt/gnam/dumper
WORDPRESS_DIR=/opt/gnam/wordpress
DB_NAME=db_name
DB_USER=db_user
DB_PASS=db_user_pass
DB_HOST=mariadb

# Create backup directory if it doesn't exist
if [ ! -d $BACKUP_DIR ]; then
  mkdir -p $BACKUP_DIR
fi

# Backup WordPress files
cd $WORDPRESS_DIR && tar -zcvf $BACKUP_DIR/wordpress_files_$DATE.tar.gz .

# Backup MariaDB database
docker exec $DB_HOST sh -c 'exec mysqldump --databases "$MYSQL_DATABASE" -u"$MYSQL_USER" -p"$MYSQL_PASSWORD"' > $BACKUP_DIR/$DB_NAME.sql

# Compress both files into one archive
cd $BACKUP_DIR && tar -zcvf backup_$DATE.tar.gz wordpress_files_$DATE.tar.gz $DB_NAME.sql

# Remove individual backups
rm $BACKUP_DIR/wordpress_files_$DATE.tar.gz
rm $BACKUP_DIR/$DB_NAME.sql

# Print completion message
echo "Backup completed successfully"