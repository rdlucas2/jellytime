# JELLYFIN LINUX SETUP:

```bash
#start all:
docker-compose up -d

#stop all:
docker-compose stop

#stop/start individual:
docker-compose stop [service_name]
docker-compose start [service_name]

#pause/unpause (no docker compose equivalent):
docker pause $(docker ps -q -f name=project_name_)
docker unpause $(docker ps -q -f name=project_name_)

docker pause projectname_servicename_1
docker unpause projectname_servicename_1

docker run cloudflare/cloudflared:latest tunnel --no-autoupdate run --token SOME_LONG_TOKEN
```

## Helpers:
- parse_flac and parse_video python files can be used to inspect metadata and rename files, but probably require some updating per file you're dealing with.

## Other Info:
- Was able to use tailscale.com and put my phone and my wife's phone in a network with my computer that's hosting jellyfin (and the associated services), basically to be able to listen to music from the media server while driving, without having to port forward and host it publicly on the internet. Had to setup a subnet from the media server to expose it, which also has the side effect of exposing all ports (but can be limited via acl lists if needed). The free plan is good enough for up to 3 users.

## The commands below have all been converted to use the docker-compose file, but are left for reference:

### Initial Setup:

# ensure that /etc/fstab is setup to mount your external storage drive (unless using other storage)
# /etc/fstab
# //readyshare/USB_Storage /mnt/z drvfs username=YOUR_USERNAME,password=YOUR_PASSWORD 0 0

# when using wsl on windows, the remote path needed to link mounted drive properly might look something like this:
# Host       : 192.168.1.9 #or whatever your local IP is
# Remote Path: \\wsl.localhost\Ubuntu-20.04\srv\sabnzbd\downloads 
# Local  Path: mapped to /complete/
# this doesn't seem to work though, reverted to using nzbget on windows and mapping to the windows path instead, like this:
# Host       : 192.168.1.9 #or whatever your local IP is
# Remote Path: C:\ProgramData\NZBGet\complete\
# Local  Path: mapped to /complete/

```bash
sudo mkdir -p /srv/sabnzbd/{config,downloads,incomplete/downloads}
sudo mkdir -p /srv/jellyfin/{config,cache}
sudo mkdir -p /srv/jellyseerr/config
sudo mkdir -p /srv/radarr/config
sudo mkdir -p /srv/sonarr/config
sudo mkdir -p /srv/lidarr/config
sudo mkdir -p /srv/readarr/config

docker pull linuxserver/sabnzbd:latest
docker pull jellyfin/jellyfin:latest  # or docker pull ghcr.io/jellyfin/jellyfin:latest
docker pull fallenbagel/jellyseerr:latest
docker pull ghcr.io/hotio/radarr:latest
docker pull ghcr.io/hotio/sonarr:latest
docker pull lscr.io/linuxserver/lidarr:latest
docker pull lscr.io/linuxserver/readarr:latest
```

### Start sabnzbd
- https://hub.docker.com/r/linuxserver/sabnzbd
```bash
docker run -d \
  --name=sabnzbd \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=America/New_York \
  -p 8080:8080 \
  -v /srv/sabnzbd/config:/config \
  -v /srv/sabnzbd/downloads:/downloads `#optional` \
  -v /srv/sabnzbd/incomplete/downloads:/incomplete-downloads `#optional` \
  --restart unless-stopped \
  lscr.io/linuxserver/sabnzbd:latest
```

### Start jellyfin:
```bash
sudo docker run -d \
 --name jellyfin \
 -v /srv/jellyfin/config:/config \
 -v /srv/jellyfin/cache:/cache \
 -v /mnt/z/jellyfin:/media \
 -p 8096:8096 \
 --privileged \
 --restart unless-stopped \
 jellyfin/jellyfin:latest
```

### Start jellyseerr:
- https://hub.docker.com/r/fallenbagel/jellyseerr
```bash
sudo docker run -d \
 --name jellyseerr \
 -e LOG_LEVEL=debug \
 -e TZ=America/New_York \
 -p 5055:5055 \
 -v /srv/jellyseerr/config:/app/config \
 --restart unless-stopped \
 fallenbagel/jellyseerr:latest
```

### Start radarr (movies):
- https://hotio.dev/containers/radarr/#__tabbed_1_1
```bash
sudo docker run -d \
    --name radarr \
    -p 7878:7878 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="America/New_York" \
    -v /srv/radarr/config:/config \
    -v /mnt/z/jellyfin/Movies:/data \
    -v /mnt/c/ProgramData/NZBGet/complete:/complete \
    -v /srv/sabnzbd/downloads:/complete \
    ghcr.io/hotio/radarr
```

### Start sonarr (shows):
- https://hotio.dev/containers/sonarr/#__tabbed_1_1
```bash
sudo docker run -d \
    --name sonarr \
    -p 8989:7878 \
    -e PUID=1000 \
    -e PGID=1000 \
    -e UMASK=002 \
    -e TZ="America/New_York" \
    -v /srv/radarr/config:/config \
    -v /mnt/z/jellyfin/Shows:/data \
    -v /mnt/c/ProgramData/NZBGet/complete:/complete \
    -v /srv/sabnzbd/downloads:/complete \
    ghcr.io/hotio/sonarr
```

### Start lidarr (music):
- https://docs.linuxserver.io/images/docker-lidarr/
```bash
sudo docker run -d \
  --name=lidarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ="America/New_York" \
  -p 8686:8686 \
  -v /srv/lidarr/config:/config \
  -v /mnt/z/jellyfin/Music:/data \
  -v /mnt/c/ProgramData/NZBGet/complete:/complete \
  -v /srv/sabnzbd/downloads:/complete \
  --restart unless-stopped \
  lscr.io/linuxserver/lidarr:latest
```

### Start lidarr (music):
- https://docs.linuxserver.io/images/docker-readarr/
```bash
docker run -d \
  --name=readarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8787:8787 \
  -v /path/to/data:/config \
  -v /path/to/books:/books `#optional` \
  -v /path/to/downloadclient-downloads:/downloads `#optional` \
  --restart unless-stopped \
  lscr.io/linuxserver/readarr:develop
```