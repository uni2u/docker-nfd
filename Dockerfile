FROM ubuntu:16.04

WORKDIR /app

ADD . /app

RUN apt-get update && \
    apt-get install -y python g++ git sudo pkg-config build-essential libsqlite3-dev libboost-all-dev libssl-dev libpcap-dev && \
    git clone https://github.com/named-data/ndn-cxx.git && \
    cd ndn-cxx && \
    ./waf configure --enable-static && \
    ./waf && \
    ./waf install && \
    ldconfig && \
    cd .. && \
    git clone --recursive https://github.com/named-data/NFD && \
    cd NFD && \
    ./waf configure && \
    ./waf && \
    ./waf install && \
    sudo cp /usr/local/etc/ndn/nfd.conf.sample /usr/local/etc/ndn/nfd.conf && \
    cd .. && \
    rm -rf ndn-cxx NFD && \
    ls

EXPOSE 6363 9696 56363

CMD ["nfd-start"]
