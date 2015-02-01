all: boot2docker-virtualbox.box

virtualbox: boot2docker-virtualbox.box

boot2docker-virtualbox.box: boot2docker.iso template.json vagrantfile.tpl \
	files/bootlocal.sh files/bootsync.sh files/docker-enter files/oem-release
	packer build -only virtualbox template.json

boot2docker.iso:
	curl -sSLO https://github.com/boot2docker/boot2docker/releases/download/v1.4.1/boot2docker.iso

files/docker-enter:
	curl -L https://raw.githubusercontent.com/YungSang/docker-attach/master/docker-nsenter -o files/docker-enter

test: test/Vagrantfile boot2docker-virtualbox.box
	@vagrant box add -f boot2docker boot2docker-virtualbox.box
	@cd test; \
	vagrant destroy -f; \
	vagrant up; \
	echo "-----> /etc/os-release"; \
	vagrant ssh -c "cat /etc/os-release"; \
	echo "-----> /etc/oem-release"; \
	vagrant ssh -c "cat /etc/oem-release"; \
	echo "-----> docker version"; \
	DOCKER_HOST="tcp://localhost:2375"; \
	docker version; \
	echo "-----> docker images -t"; \
	docker images -t; \
	echo "-----> docker ps -a"; \
	docker ps -a; \
	echo "-----> nc localhost 8080"; \
	nc localhost 8080; \
	echo '-----> docker-enter `docker ps -l -q` ls -l'; \
	vagrant ssh -c 'docker-enter `docker ps -l -q` ls -l'; \
	echo '-----> docker exec `docker ps -l -q` ls -l'; \
	docker exec `docker ps -l -q` ls -l; \
	vagrant suspend

clean:
	cd test; vagrant destroy -f
	rm -f boot2docker.iso
	rm -f files/docker-enter
	rm -f boot2docker-virtualbox.box
	rm -rf output-*/

.PHONY: test clean
