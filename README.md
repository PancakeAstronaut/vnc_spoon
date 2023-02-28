# Dockerized Spoon that runs via VNC (https://hub.docker.com/r/shengeli/vnc_spoon)
----------------------------------------------------------

## Testing done on Fedora 37 & Ubuntu 22.04
### ARCH: AMD64

#### Run the container locally with debug output
- `docker run -t -p 5900:5900 shengeli/vnc_spoon:amd64`

#### Run the container locally in detached mode
- `docker run -d -t -p 5900:5900 shengeli/vnc_spoon:amd64`

#### Need to attach a directory to the container?
- `docker volume create --driver local --opt type=none --opt device=/home/<user>/<path>/<to>/<desired>/<transforms> --opt o=bind <vol_name>`
- `docker run -d -t -v <vol_name>:/local_transforms -p 5900:5900 shengeli/vnc_spoon:amd64`
- This will run the container with a directory `/local_transforms` that persists to wherever the volume device is. 

### TODO 
- Add arm build for Apple Silicon (possibly) 
- docker scan on image to fix vulnerabilities (I assume there are a few) 
