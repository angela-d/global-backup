# Global Automated Site and Database Backups
Backup script to automate gzipped/compressed backups of both databases and website directory content.
Tested & operable out-of-the-box in Debian / Ubuntu / CentOs Linux distributions; may work in others, your mileage may vary.

> ## Features
> Seamlessly & silently generate backups of both databases and website/configuration content
> Automate purging of obsolete backups (default is five-day intervals)

## Configure your script
 * Add backup.sh to your desired path on your server (ideally, above a public directory and with root access) -- do not store backups in **public**ly accessible directories, for obvious reasons.
 * Create a database user with root access (tweak privileges accordingly; ideally this user will be only used for backups!)
 * Add database credentials to backup.sh and specify where you'd like to store your backups (again, DO NOT store them in publicly accessible directories!) - if you're using the default paths set in the script, ensure you create the folders as they are not native
 * Add the directories you want to exclude by changing the `--exclude='/var/www/exclude_dir'` and `--exclude='/var/www/exclude_dir1'` lines, respectively.
 * To change the frequency in which your backups are automatically purged, adjust `-mtime +5` to whatever you want; ie. to purge 7 day old backups, change to: `-mtime +7`
 
 ## Install
 Add a cron, if you wish for the script to be run nightly:
 
 *As root*, run: 
 
 1)`crontab -e` to open the cron editor
 
 2) Add to the bottom of the crontab: 
 ```bash
 45 2 * * * /your/path/backup.sh` to run a backup every morning at 2:45am
 ```
 
 3) Ensure the file is executable:
 ```bash
 chmod +x /your/path/backup.sh
 ```
 
 4) Test it: `sh /your/path/backup.sh` and you should see the backup progress in your terminal.
 
 ###### Notes
 If you're using this script to backup your configuration or home directories of your Linux desktop, you won't need root access to enable the cron *or* backup location, so as long as you're saving the backups to a non-root directory (just make sure you don't save them to a folder where the backup will be scraping from, else you'll end up with major bloat).
 
 ###### Known Bugs
 The database backup saves the file as `data`; should you need to use it, just rename to `data.sql` - Probably something I could fix inside the script, but it's at the bottom of my to-do list, for now.  Any backups I've restored from these automated backups has restored flawlessly.
