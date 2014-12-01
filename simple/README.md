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
Since this container is running as daemon, we can get its status with `docker ps`

```
dockeruser@docker-vm:~$ docker ps
CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS               NAMES
f5361a5bce02        ubuntu:14.04        /bin/sh -c 'while tr   10 minutes ago      Up 10 minutes                           hello_daemon        
```


We can stop a container, `docker stop hello_daemon`

#### Create Docker Images
- create a project directory, `mkdir webserver`, then 
- change it to project directory, `cd webserver`,
- use text editor to create a Dockerfile, with contents:

- build image, in the project directory, where Dockerfile is located, 

```
dockeruser@docker-vm:~/Projects/webserver$ docker build -t="rkuo/webserver" .
... [snip] ...
Step 5 : expose 80
 ---> Running in 01a7494bde6b
 ---> f595086394a8
Removing intermediate container 01a7494bde6b
Successfully built f595086394a8
dockeruser@docker-vm:~/Projects/webserver$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
rkuo/webserver      latest              f595086394a8        57 seconds ago      231.8 MB
ubuntu              14.04               86ce37374f40        4 days ago          192.7 MB
busybox             latest              e72ac664f4f0        8 weeks ago         2.433 MB
```

inspect the image we just created,
```
dockeruser@docker-vm:~/Projects/webserver$ docker images rkuo/webserver
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
rkuo/webserver      latest              f595086394a8        35 minutes ago      231.8 MB
dockeruser@docker-vm:~/Projects/webserver$ docker history f595
IMAGE               CREATED             CREATED BY                                      SIZE
f595086394a8        36 minutes ago      /bin/sh -c #(nop) EXPOSE map[80/tcp:{}]         0 B
95c0a1aa50bb        36 minutes ago      /bin/sh -c echo 'hi everyone, from nginx cont   34 B
d2a6866edd3e        36 minutes ago      /bin/sh -c apt-get install -y nginx             18.46 MB
80bebd9cb2ac        About an hour ago   /bin/sh -c apt-get update                       20.65 MB
a841d55ca903        About an hour ago   /bin/sh -c #(nop) MAINTAINER Richard Kuo "kuo   0 B
86ce37374f40        4 days ago          /bin/sh -c #(nop) CMD [/bin/bash]               0 B
dc07507cef42        4 days ago          /bin/sh -c apt-get update && apt-get dist-upg   0 B
78e82ee876a2        4 days ago          /bin/sh -c sed -i 's/^#\s*\(deb.*universe\)$/   1.895 kB
3f45ca85fedc        4 days ago          /bin/sh -c rm -rf /var/lib/apt/lists/*          0 B
61cb619d86bc        4 days ago          /bin/sh -c echo '#!/bin/sh' > /usr/sbin/polic   194.8 kB
5bc37dc2dfba        4 days ago          /bin/sh -c #(nop) ADD file:d11cc4a4310c270539   192.5 MB
511136ea3c5a        17 months ago                                                       0 B
dockeruser@docker-vm:~/Projects/webserver$ 
```
Run a container,
```
dockeruser@docker-vm:~/Projects/webserver$ docker run -d -p 80 --name web rkuo/webserver nginx -g "daemon off;"
216975f80cf25558beab3dabe876cafa758eed1964f529ed8781b5eb291b37cc
```
A container is created, to find out IPAddress and which host port mapped to 80,
```
dockeruser@docker-vm:~/Projects/webserver$ docker inspect web | grep IPAddress
        "IPAddress": "172.17.0.14",
dockeruser@docker-vm:~/Projects/webserver$ docker ps -l
CONTAINER ID        IMAGE                   COMMAND                CREATED             STATUS              PORTS                   NAMES
216975f80cf2        rkuo/webserver:latest   nginx -g 'daemon off   31 minutes ago      Up 31 minutes       0.0.0.0:49153->80/tcp   web                 
```
With a web browser, we can use either 0.0.0.0:49153 or 172.17.0.14:80 to access index.html. 

If you are using an Non-GUI based VM, we can use curl to test our container. Check whether we have curl install in the VM, for ubuntu, `dpkg -s curl`; if it is not installed, type `sudo apt-get install curl`. You may need to enter the password to install the package.

```
dockeruser@docker-vm:~/Projects/webserver$ curl http://0.0.0.0:49153
hi everyone, from nginx container
```

You can create a images from your github account too. 

```
dockeruser@docker-vm:~/Projects/webserver$ docker build -t="rkuo/webfromgit:v2" git://github.com/rkuo/learningDocker.git
Sending build context to Docker daemon 62.98 kB
Sending build context to Docker daemon 
Step 0 : from ubuntu:14.04
 ---> 86ce37374f40
Step 1 : maintainer Richard Kuo "kuotie@gmail.com"
 ---> Using cache
 ---> a841d55ca903
Step 2 : run apt-get update
 ---> Using cache
 ---> 80bebd9cb2ac
Step 3 : run apt-get install -y nginx
 ---> Using cache
 ---> d2a6866edd3e
Step 4 : run echo 'hi everyone, this is from nginx container in git'    > /usr/share/nginx/html/index.html
 ---> Running in fc54ad0d65ed
 ---> 0600f29eb7e9
Removing intermediate container fc54ad0d65ed
Step 5 : expose 80
 ---> Running in 3ab5dbc21d36
 ---> 16d65c4feca1
Removing intermediate container 3ab5dbc21d36
Successfully built 16d65c4feca1
dockeruser@docker-vm:~/Projects/webserver$ 
``` 

Multiple versions can be created with different tags,

```
dockeruser@docker-vm:~/Projects/webserver$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
rkuo/webfromgit     v2                  16d65c4feca1        2 minutes ago       231.8 MB
rkuo/webserver      latest              f595086394a8        2 hours ago         231.8 MB
rkuo/webfromgit     v1                  f595086394a8        2 hours ago         231.8 MB
ubuntu              14.04               86ce37374f40        4 days ago          192.7 MB
busybox             latest              e72ac664f4f0        8 weeks ago         2.433 MB
```

We can test this github version,

```
dockeruser@docker-vm:~/Projects/webserver$ docker run -d -p 80 --name web2 rkuo/webfromgit:v2 nginx -g "daemon off;"
1ca1b2c5a02cfd5c4505cee90080e8e3315d43f2c682d951d0afbacdf0399a57
dockeruser@docker-vm:~/Projects/webserver$ docker ps
CONTAINER ID        IMAGE                COMMAND                CREATED             STATUS              PORTS                   NAMES
1ca1b2c5a02c        rkuo/webfromgit:v2   nginx -g 'daemon off   8 seconds ago       Up 7 seconds        0.0.0.0:49154->80/tcp   web2                
216975f80cf2        rkuo/webfromgit:v1   nginx -g 'daemon off   About an hour ago   Up About an hour    0.0.0.0:49153->80/tcp   web                 
f5361a5bce02        ubuntu:14.04         /bin/sh -c 'while tr   5 hours ago         Up 5 hours                                  hello_daemon        
dockeruser@docker-vm:~/Projects/webserver$ curl http://0.0.0.0:49154
hi everyone, this is from nginx container in git
dockeruser@docker-vm:~/Projects/webserver$ 
```
It works. It displays different message from index.html.

### Persist Data 
- volume [reference](http://crosbymichael.com/advanced-docker-volumes.html)
- mount host directory to docker, host is the VM we use, not Macbook
- `mkdir ~/www`, then create a docker with volume option.

```
dockeruser@docker-vm:~$ mkdir www
dockeruser@docker-vm:~$ ls
Desktop  Documents  Downloads  examples.desktop  Music  Pictures  Projects  Public  Templates  Videos  www
dockeruser@docker-vm:~$ docker run -it --name wvolume -v ~/www ubuntu echo yo
Unable to find image 'ubuntu' locally
Pulling repository ubuntu
86ce37374f40: Download complete 
... [snip] ...
```

do a inspection of container `docker inspect 355b`

```
	"HostnamePath": "/var/lib/docker/containers/355bf74fd807e280be9927452b23e82109d14d590f8738b3b13b067b3eb17a91/hostname",
    "HostsPath": "/var/lib/docker/containers/355bf74fd807e280be9927452b23e82109d14d590f8738b3b13b067b3eb17a91/hosts",
... [snip] ...
    "Volumes": {
        "/home/dockeruser/www": "/var/lib/docker/vfs/dir/1ca0f6fa92754c571724da3e7153e65765cc2b02f3e19d9c36b44f5d79e22b17"
    },
    "VolumesRW": {
        "/home/dockeruser/www": true
    }
```

Data Volume Example:

- Create web content
Define a Dockerfile with a hook to volume (to be defined later in run command)

```
# Version 0.0.2
# This file needs to be in the host with Docker installed.
# Reference for indix file, http://stackoverflow.com/questions/10674867/nginx-default-public-www-location

from ubuntu:14.04
maintainer Richard Kuo "kuotie@gmail.com"
env refreshed_at 2014-11-30

run apt-get update
run apt-get -y -q install nginx
run mkdir -p /var/www/html/website 	# map to host directory in run

add nginx/global.conf /etc/nginx/conf.d/global.conf
add nginx/nginx.conf /etc/nginx/nginx.conf

expose 80
```

Build image,

```
dockeruser@docker-vm:~/Projects/webserver$ docker build -t rkuo/nginx:v2 .
```

Fetch content,

```
dockeruser@docker-vm:~/Projects/webserver/website$ wget http://www.dockerbook.com/code/5/sample/website/
--2014-11-30 18:50:25--  http://www.dockerbook.com/code/5/sample/website/
... [snip] ...
```

Create container and link the data from host to container,

```
dockeruser@docker-vm:~/Projects/webserver$ sudo docker run -d -p 80 --name website -v $PWD/website:/var/www/html/website rkuo/nginx:v6 nginx
[sudo] password for dockeruser: 
778222613ed9e4dd44b599b9e781590ac8debb9deff95d3dbc7e7f906d6c965c
dockeruser@docker-vm:~/Projects/webserver$ curl 0.0.0.0:49153
<head>
<title>Test website</title>
</head>
<body>
<h1>This is a test website</h1>
</body>
```

Data container (**start from here later**)

