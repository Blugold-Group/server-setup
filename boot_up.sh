#!/bin/bash

sudo -u pi /home/pi/CTF_Scoreboard/env/bin/gunicorn --access-logfile "/home/pi/logs/gunicorn_access.log" -w 3 -b 0.0.0.0:5000 app:app --chdir /home/pi/CTF_Scoreboard > /home/pi/logs/gunicorn.log 2>&1 &
sudo -u pi cloudflared tunnel run <cloudflare_tennel_uuid> /home/pi/logs/tunnel.log 2>&1 &
sudo -u pi ssh -R 2223:localhost:22 <remote_ssh_acesss_server_ip -N > /home/pi/logs/ssh_tunnel.log 2>&1 &
