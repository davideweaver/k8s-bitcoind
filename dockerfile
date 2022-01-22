FROM debian:buster

WORKDIR /root

RUN apt update && \
    apt install -y wget build-essential autoconf libtool pkg-config bsdmainutils libboost-all-dev libevent-dev && \
    wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz && \
    tar xzf bitcoin-22.0.tar.gz && \
    mv bitcoin-22.0 bitcoin && \
    cd bitcoin && \
    ./autogen.sh && \
    ./configure --disable-wallet && \
    make -j4 && \
    make install && \
    cd .. && \
    rm bitcoin-22.0.tar.gz && \
    rm -rf bitcoin && \
    apt clean

COPY ./bitcoin.conf /root/bitcoin.conf

EXPOSE 8332 8333

CMD /bin/bash -c "bitcoind --conf=/root/bitcoin.conf"