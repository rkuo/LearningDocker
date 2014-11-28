# Get Started with Docker

## Setup ##
### Create a VM in VirtualBox ###
- setup virtualbox [download](https://www.virtualbox.org/wiki/Downloads), [install](http://www.virtualbox.org/manual/ch01.html#intro-installing)
- check your host OS in [Windows](http://windows.microsoft.com/en-us/windows7/find-out-32-or-64-bit), or in [Mac](http://support.apple.com/en-us/HT201948), download OS iso, [ubuntu desktop](http://www.ubuntu.com/download/desktop), This [post](http://blenderfox.com/2014/09/14/building-docker-io-on-32-bit-arch/) describes how to compile your own 32 bits Docker, but Docker community only support 64 bit OS; most of images in Docker registry may not work with 32 bit Docker. We need a 64 bit OS.
- [install Ubuntu on VirtualBox](http://www.wikihow.com/Install-Ubuntu-on-VirtualBox)
- project directory for vm location=~/Project/docker/ubtu-dsktp-docker-hacking
- vm name=docker-vm
- username=dockeruser, password=password

- download pre-built vm images, see my email for url. 

### Install Docker
- [install Docker on ubuntu](http://docs.docker.com/installation/ubuntulinux/)
- add `sudo ln -sf /usr/bin/docker.io /usr/local/bin/docker`

```
# Add the docker group if it doesn't already exist.
$ sudo groupadd docker

# Add the connected user "${USER}" to the docker group.
# Change the user name to match your preferred user.
# You may have to logout and log back in again for
# this to take effect.
$ sudo gpasswd -a ${USER} docker

# Restart the Docker daemon.
# If you are in Ubuntu 14.04, use docker.io instead of docker
$ sudo service docker restart
```

- download image with docker pre-installed, in dropbox
- [import pre-built vm image](http://grok.lsu.edu/article.aspx?articleid=13838)
- check Docker installation, `docker info`

## Use Docker

### Run a Docker Container
#### Pull from Repository
- busybox
`docker run --name busy busybox echo hi
- web server

#### Create Docker Images
- dockerfile
 
### Persist Data 
- volume
- data container

### Link Containers
