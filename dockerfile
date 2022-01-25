FROM debian:buster-slim as builder

WORKDIR /root

RUN apt update && apt install --yes wget && \
    wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz && \
    tar xzf bitcoin-22.0.tar.gz && mv bitcoin-22.0 bitcoin && \
    rm -rf bitcoin-22.0.tar.gz

RUN apt install --yes build-essential autoconf libtool pkg-config \
    bsdmainutils libboost-all-dev libevent-dev

RUN cd bitcoin && ./autogen.sh && ./configure --disable-wallet && \
    make -j4 && make install && cd /root && rm -rf bitcoin && apt clean && \
    rm /usr/local/bin/test_bitcoin && rm /usr/local/bin/bench_bitcoin

COPY ./bitcoin.conf /root/bitcoin.conf

EXPOSE 8332 8333

CMD /bin/bash -c "bitcoind --conf=/root/bitcoin.conf"