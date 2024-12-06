
# Bitcoin Core v27.0: Docker Quick Start Guide

Welcome to the Quick Start Guide for running Bitcoin Core v27.0 using Docker. This guide will walk you through the process of setting up and running Bitcoin Core on your machine, providing two options: using Docker Compose or running the Docker image manually. Follow the steps below to get started quickly and efficiently.

---

## Prerequisites

Before you begin, ensure you have the following installed on your system:

1. **Docker**: Install Docker by following the instructions for your operating system here [here](https://docs.docker.com/get-docker/).

2. ***Docker Compose***: Install Docker Compose by following the instructions here [here](https://docs.docker.com/compose/install/).

3. ***Git***: If you plan to use Docker Compose, you’ll need Git to clone the repository. Install Git by following the instructions here [here](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git).

---

## Option 1: Using Docker Compose

This is the easiest and most convenient way to get Bitcoin Core up and running.

### Step 1: Clone the Repository

First, download the repository containing the Docker Compose configuration:

```bash
git clone https://github.com/raine-works/bitcoin-core.git
```

This will create a local copy of the repository in a directory called bitcoin-core.

### Step 2: Start Bitcoin Core

Navigate to the newly created directory and use Docker Compose to start Bitcoin Core:

```bash
cd bitcoin-core
docker compose up -d
```

The -d flag runs the container in detached mode, allowing it to run in the background.

### Step 3: Verify the Service is Running

Check that the Bitcoin Core container is running:

```bash
docker ps
```

You should see an entry for bitcoin-core with its status listed as "Up."

## Option 2: Using the Docker Image Directly

If you prefer not to use Docker Compose, you can pull the Docker image and run it manually.

### Step 1: Pull the Docker Image

Download the prebuilt Docker image from GitHub Container Registry:

```bash
docker pull ghcr.io/raine-works/bitcoin-core:latest
```

This command ensures you have the latest version of the image available.

### Step 2: Run the Docker Container

Run the Docker container with the following command:

```bash
docker run -p 8333:8333 -v /mnt/btc_core:/mnt/btc_core --name btc-core ghcr.io/raine-works/bitcoin-core:latest
```

Explanation of the Options:
- -p 8333:8333: Maps port 8333 on the host to port 8333 in the container, allowing Bitcoin network connections.

- -v /mnt/btc_core:/mnt/btc_core: Binds a host directory (/mnt/btc_core) to the container’s data directory (/mnt/btc_core) for persistent storage.

- --name btc-core: Names the container btc-core for easy reference.

### Step 3: Verify the Service is Running

Check the running containers to confirm Bitcoin Core is up and running:

```bash
docker ps
```

You should see an entry named btc-core with its status listed as "Up."

## Stopping the Bitcoin Core Container

To stop Bitcoin Core, use the following command:

```bash
docker stop btc-core
```

If you used Docker Compose, you can stop the service with:

```bash
docker compose down
```

### Accessing Bitcoin Core Logs
To monitor Bitcoin Core’s activity and debug any issues, view the logs using:

- For Docker Compose:

```bash
docker compose logs -f
```

- For standalone Docker:

```bash
docker logs -f btc-core
```

The -f flag keeps the logs streaming in real-time.

### Persistent Data Storage

The container is configured to store blockchain data in a persistent volume. Ensure the directory /mnt/btc_core exists on your host machine. This setup ensures that your data is retained even if the container is stopped or removed.

### Networking Notes

Bitcoin Core uses port 8333 to communicate with the Bitcoin network. Ensure this port is open on your host machine’s firewall to allow connections.

### Conclusion
You are now ready to run Bitcoin Core v27.0 using Docker! Whether you chose Docker Compose for simplicity or the manual method for greater control, this guide has equipped you with the steps needed to get started. For further customization, refer to the official [Bitcoin Core documentation](https://bitcoin.org/en/full-node).