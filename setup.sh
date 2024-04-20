#!/bin/bash

# Create directories
sudo mkdir -p /srv/sabnzbd/{config,downloads,incomplete/downloads}
sudo mkdir -p /srv/jellyfin/{config,cache}
sudo mkdir -p /srv/jellyseerr/config
sudo mkdir -p /srv/radarr/config
sudo mkdir -p /srv/sonarr/config
sudo mkdir -p /srv/lidarr/config
sudo mkdir -p /srv/readarr/config

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
