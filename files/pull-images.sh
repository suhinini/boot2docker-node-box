#!/bin/sh

sudo /etc/init.d/docker start
while [ "$(sudo /etc/init.d/docker status)" != "Docker daemon is running" ]; do echo 'Waiting for Docker daemon to start...'; sleep 1; done

sudo docker pull busybox

sudo docker pull golang

sudo /etc/init.d/docker stop
