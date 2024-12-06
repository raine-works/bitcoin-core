FROM ubuntu:24.04 AS base
WORKDIR /mnt/btc_core
SHELL ["/bin/bash", "-c"]

RUN apt-get update
RUN apt-get upgrade -y
RUN apt-get install -y wget zip unzip

RUN wget https://bitcoin.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz 
RUN tar xzf bitcoin-27.0-x86_64-linux-gnu.tar.gz 
RUN install -m 0755 -o root -g root -t /usr/local/bin bitcoin-27.0/bin/*

WORKDIR /home/btc_core_user

RUN mkdir ./.bitcoin
RUN mkdir /mnt/btc_core/btc_data
RUN cp /mnt/btc_core/bitcoin-27.0/bitcoin.conf ./.bitcoin/
RUN sed -i 's/#datadir=<dir>/datadir=\/mnt\/btc_core\/btc_data/' ./.bitcoin/bitcoin.conf

RUN groupadd -g 1001 btc_core_group
RUN useradd -u 1001 -g btc_core_group -s /bin/bash -m btc_core_user
RUN chown -R btc_core_user:btc_core_group /home/btc_core_user
RUN chown -R btc_core_user:btc_core_group /mnt/btc_core

EXPOSE 8333
USER btc_core_user
LABEL org.opencontainers.image.source="https://github.com/raine-works/bitcoin-core"