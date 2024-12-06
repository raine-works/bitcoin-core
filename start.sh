#!/bin/bash

# Start Tor in the background
service tor start

# Wait for the Tor hidden service address to be generated
for i in {1..30}; do
  if [ -f /var/lib/tor/bitcoin-service/hostname ]; then
    break
  fi
  echo "Waiting for Tor hidden service..."
  sleep 2
done

if [ ! -f /var/lib/tor/bitcoin-service/hostname ]; then
  echo "Error: Tor hidden service address not found"
  exit 1
fi

# Get the Tor onion address
ONION_ADDR=$(cat /var/lib/tor/bitcoin-service/hostname)

# Get the public IP address
PUBLIC_IP=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Add the external addresses to the bitcoin.conf
echo "externalip=$ONION_ADDR" >> /home/btc_core_user/.bitcoin/bitcoin.conf
echo "externalip=$PUBLIC_IP" >> /home/btc_core_user/.bitcoin/bitcoin.conf

# Start Bitcoin Core
trap 'bitcoin-cli stop; sleep 5' SIGTERM
exec bitcoind -datadir=/mnt/btc_core/btc_data
