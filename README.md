# Server Setup

At the time of this writing, the blugold group website (blugold.group) is hosted on a raspberry pi located in the lab. Over the winterim 2024-2025 (the year of the club's founding), it was moved to Jack's (the founder's) house and set up on an internet accessible website for a winterim CTF.

This repo contains the scripts that make it run.

## daily_maintenance.sh

Updates all of the software on the pi, the dependencies on ther server (without checking for breaking upgrades), and gets the newest version of the server, then reboots

## boot_up.sh

Starts the server, the Cloudflare tunnel, and the tunnel to the remote ssh server

## backup_database.sh

Makes a copy of the server database to /backups if there's a change. Runs everyday. Was born from an error of jack overwriting the database, which wasn't backed up
