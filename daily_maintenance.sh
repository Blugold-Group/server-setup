#!/bin/bash

LOGFILE="/home/pi/logs/daily_upgrade.log"
PIP_USER="pi"

# Error handling function
handle_error() {
    local exit_code=$1
    local msg=$2
    echo "$(date) - ERROR: $msg" >> $LOGFILE

    curl -d "$msg" <alert ntfy.sh url>

    exit $exit_code
}

# Update system packages with apt
echo "$(date) - Starting system update with apt" >> $LOGFILE

apt -y update >> $LOGFILE 2>&1
apt -y upgrade >> $LOGFILE 2>&1

if [ $? -ne 0 ]; then
    handle_error $? "apt update failed"
fi

# Update Flask with pip
echo "$(date) - Updating Flask with pip" >> $LOGFILE

sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade Flask >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade gunicorn >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade itsdangerous >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade idna >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade Jinja2 >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade libcomps >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade libxml >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade Markdown >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade pip >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade ptyprocess >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade requests >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade urllib3 >> $LOGFILE 2>&1
sudo -u $PIP_USER /home/pi/CTF_Scoreboard/env/bin/pip install --upgrade Werkzeug >> $LOGFILE 2>&1

if [ $? -ne 0 ]; then
    handle_error $? "pip update failed"
fi

# Fetch new code from the repository
echo "$(date) - Fetching new code from repository" >> $LOGFILE

sudo -u pi git -C /home/pi/CTF_Scoreboard/ reset --hard origin/main >> $LOGFILE 2>&1
sudo -u pi git -C /home/pi/CTF_Scoreboard/ pull >> $LOGFILE 2>&1

if [ $? -ne 0 ]; then
    handle_error $? "git pull failed"
fi

# Reboot the system
echo "$(date) - Rebooting the system" >> $LOGFILE
reboot now
