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
# **In VM, with docker installed**,
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
`docker run --name busy busybox echo hi`
or 

```
dockeruser@docker-vm:~$ docker run --name richard -it ubuntu:14.04 /bin/bash
Unable to find image 'ubuntu:14.04' locally
Pulling repository ubuntu
86ce37374f40: Pulling dependent layers 
... [snip] ...
```
This will install ubuntu images, version 14.04.

```
root@c0a64302f2ed:/# ls  
bin  boot  dev	etc  home  lib	lib64  media  mnt  opt	proc  root  run  sbin  srv  sys  tmp  usr  var
root@c0a64302f2ed:/# hostname
c0a64302f2ed
root@c0a64302f2ed:/# 
```

We can inspect docker's process, `docker top hell_daemon`

```
dockeruser@docker-vm:~$ docker run --name hello_daemon -d ubuntu:14.04 /bin/sh -c "while true; do echo hello; sleep 1; done"
f5361a5bce02ec97ed08c08578ab49eb61b2fe262393ac48bca67057d3487fce
dockeruser@docker-vm:~$ docker top hello_daemon 
UID                 PID                 PPID                C                   STIME               TTY                 TIME                CMD
root                3497                1256                0                   11:22               ?                   00:00:00            /bin/sh -c while true; do echo hello; sleep 1; done
root                3561                3497                0                   11:22               ?                   00:00:00            sleep 1
dockeruser@docker-vm:~$ docker logs hello_daemon 
hello
hello
hello
hello
... [snip] ...
```

We can stop a container, `docker stop hello_daemon`

#### Create Docker Images
- create a project directory, `mkdir dockerproj1`, then 
- change it to project directory, `cd dockerproj1`,
- use text editor to create a Dockerfile, with contents:


- web server (**start from here later**)
 
### Persist Data 
- volume
- data container

### Link Containers
