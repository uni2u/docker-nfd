# docker-nfd
docker on nfd

## docker install

```
sudo apt-get update
sudo apt-get install apt-transport-https ca-certificates

sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

sudo vim /etc/apt/sources.list.d/docker.list
deb https://apt.dockerproject.org/repo ubuntu-xenial main

sudo apt-get update

sudo apt-get purge lxc-docker

apt-cache policy docker-engine

sudo apt-get install linux-image-extra-$(uname -r)

sudo apt-get install docker-engine

sudo usermod -aG docker $USER

sudo service docker start
```

## Tutorial

The following give you a NDN ping

```
git clone --depth 1 https://github.com/uni2u/docker-nfd.git
docker build -t ndn:test docker-nfd/

git clone --depth 1 https://github.com/uni2u/docker-nfd-ping.git
docker build -t ndntools docker-nfd-ping/

docker run -it --rm --name ping -p 6363:6363 ndntools /bin/bash
nfd-start
ndn-repo-ng
```

On another terminal run

```
docker exec -it ping /bin/bash
cd ndn-tools

ndnping ndn:/edu/arizona
ndnping -c 4 -t ndn:/edu/arizona
```

On another terminal run

```
docker exec -it ping /bin/bash
cd ndn-tools

ndnpingserver ndn:/edu/arizona
ndnpingserver -p 4 ndn:/edu/arizona
```

## Reference

### create dockerfile

```
# This is based on the instructions from:
# http://named-data.net/doc/NFD/0.2.0/INSTALL.html#install-nfd-using-the-ndn-ppa-repository-on-ubuntu-linux

FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install -y software-properties-common

RUN add-apt-repository -y ppa:named-data/ppa
RUN apt-get update
RUN apt-get install -y nfd
```

### build docker image
Open the terminal and change a new directory
Then input docker build command

```
docker build -t named_data/nfd
```

### run docker process

```
docker run --rm -ti named_data/nfd /bin/bash
```

### Docker Tutorial or Document
* https://www.docker.com/tryit/
* https://docs.docker.com/
