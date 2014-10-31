FROM debian:latest

RUN apt-get update && apt-get -y install btrfs-tools

ENTRYPOINT ["mkfs.btrfs", "-L", "boot2docker-data", "/hostdev/sda"]
