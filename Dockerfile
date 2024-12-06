FROM ubuntu:24.04 AS base
WORKDIR /mnt/btc_core
SHELL ["/bin/bash", "-c"]

# Update and install required packages
RUN apt-get update && apt-get upgrade -y \
    && apt-get install -y wget zip unzip nano tor dnsutils

# Download and install Bitcoin Core
RUN wget https://bitcoin.org/bin/bitcoin-core-27.0/bitcoin-27.0-x86_64-linux-gnu.tar.gz \
    && tar xzf bitcoin-27.0-x86_64-linux-gnu.tar.gz \
    && install -m 0755 -o root -g root -t /usr/local/bin bitcoin-27.0/bin/*

# Create user and set permissions
RUN groupadd -g 1001 btc_core_group \
    && useradd -u 1001 -g btc_core_group -s /bin/bash -m btc_core_user \
    && chown -R btc_core_user:btc_core_group /mnt/btc_core

# Prepare Bitcoin Core data directories and configuration
RUN mkdir -p /home/btc_core_user/.bitcoin /mnt/btc_core/btc_data \
    && echo "datadir=/mnt/btc_core/btc_data" >> /home/btc_core_user/.bitcoin/bitcoin.conf \
    && echo "maxconnections=100" >> /home/btc_core_user/.bitcoin/bitcoin.conf \
    && echo "onion=127.0.0.1:9050" >> /home/btc_core_user/.bitcoin/bitcoin.conf \
    && echo "listen=1" >> /home/btc_core_user/.bitcoin/bitcoin.conf \
    && echo "discover=1" >> /home/btc_core_user/.bitcoin/bitcoin.conf

# Configure Tor Hidden Service
RUN echo "HiddenServiceDir /var/lib/tor/bitcoin-service/" >> /etc/tor/torrc \
    && echo "HiddenServicePort 8333 127.0.0.1:8333" >> /etc/tor/torrc \
    && service tor restart \
    && for i in {1..30}; do [ -f /var/lib/tor/bitcoin-service/hostname ] && break || { echo "Waiting for Tor hidden service..."; sleep 2; }; done \
    && echo "externalip=$(cat /var/lib/tor/bitcoin-service/hostname)" >> /home/btc_core_user/.bitcoin/bitcoin.conf 

# Expose Bitcoin Core port
EXPOSE 8333

# Run Bitcoin Core and Tor
WORKDIR /home/btc_core_user
USER btc_core_user
ENTRYPOINT ["/bin/bash", "-c", "trap 'bitcoin-cli stop; sleep 5' SIGTERM && bitcoind"]
LABEL org.opencontainers.image.source="https://github.com/raine-works/bitcoin-core"
