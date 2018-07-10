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

## simple docker install (ubuntu 16.04)

```
curl -sSL https://get.docker.com/ | sh
or
wget -qO- https://get.docker.com/ | sh
```

## docker network with ovs

```
sudo apt-get install -y openvswitch-switch bridge-utils
sudo service docker stop
sudo ip link set dev docker0 down
sudo brctl delbr docker0
sudo iptables -t nat -F POSTROUTING
```

* server01
```
sudo brctl addbr docker0
sudo ip addr add 10.0.0.1/24 dev docker0
sudo ip link set dev docker0 up

sudo ovs-vsctl add-br br-int
sudo ovs-vsctl add-port br-int vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip=<server2_IP>
sudo ip link add veth_sw0 type veth peer name veth_d0
sudo ovs-vsctl add-port br-int veth_sw0
sudo brctl addif docker0 veth_d0
sudo ip link set dev veth_sw0 up
sudo ip link set dev veth_d0 up
```

* server02
```
sudo brctl addbr docker0
sudo ip addr add 10.0.0.2/24 dev docker0
sudo ip link set dev docker0 up

sudo ovs-vsctl add-br br-int
sudo ovs-vsctl add-port br-int vxlan0 -- set Interface vxlan0 type=vxlan options:remote_ip=<server1_IP>
sudo ip link add veth_sw0 type veth peer name veth_d0
sudo ovs-vsctl add-port br-int veth_sw0
sudo brctl addif docker0 veth_d0
sudo ip link set dev veth_sw0 up
sudo ip link set dev veth_d0 up
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
