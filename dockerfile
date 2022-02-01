FROM debian:buster-slim as builder

WORKDIR /root

RUN apt update && \
    apt install -y wget && \
    wget https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0-x86_64-linux-gnu.tar.gz && \
    tar xzf bitcoin-22.0-x86_64-linux-gnu.tar.gz && \
    mv bitcoin-22.0 bitcoin && \
    rm -rf bitcoin-22.0-x86_64-linux-gnu.tar.gz && \
    cp ./bitcoin/bin/bit* /usr/local/bin && \
    rm -rf bitcoin && \
    apt clean

COPY ./bitcoin.conf /root/bitcoin.conf

EXPOSE 8332 8333

CMD /usr/local/bin/bitcoind -testnet -conf=/root/bitcoin.conf -datadir=/data -debuglogfile=/root/debug.log
