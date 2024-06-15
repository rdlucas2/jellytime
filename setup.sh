#!/bin/bash

# Create directories
sudo mkdir -p /home/ryan/srv/sabnzbd/{config,downloads,incomplete/downloads}
sudo mkdir -p /home/ryan/srv/jellyfin/{config,cache}
sudo mkdir -p /home/ryan/srv/jellyseerr/config
sudo mkdir -p /home/ryan/srv/radarr/config
sudo mkdir -p /home/ryan/srv/sonarr/config
sudo mkdir -p /home/ryan/srv/lidarr/config
sudo mkdir -p /home/ryan/srv/readarr/config

# ensure that /etc/fstab is setup to mount your external storage drive (unless using other storage)
# /etc/fstab
# //readyshare/USB_Storage /mnt/z drvfs username=YOUR_USERNAME,password=YOUR_PASSWORD 0 0

# # Pull Docker images
# docker pull linuxserver/sabnzbd:latest
# docker pull jellyfin/jellyfin:latest
# docker pull fallenbagel/jellyseerr:latest
# docker pull ghcr.io/hotio/radarr:latest
# docker pull ghcr.io/hotio/sonarr:latest
# docker pull lscr.io/linuxserver/lidarr:latest
# docker pull lscr.io/linuxserver/readarr:latest
