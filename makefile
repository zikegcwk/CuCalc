build:
	docker build -t smc_cuda .
run:
	mkdir -p /srv/cocalc/ && docker run --restart unless-stopped --gpus all --name cucalc -v /srv/cocalc:/projects -p 443:443 smc_cuda &
start:
	sudo docker start cucalc
stop:
	sudo docker stop cucalc
rm:
	sudo docker rm cucalc

