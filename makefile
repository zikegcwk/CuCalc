build:
	docker build -t smc_cuda .
run:
	docker run --restart unless-stopped --gpus all --name cucalc -v ~/cocalc:/projects -p 443:443 smc_cuda &
start:
	sudo docker start cucalc
stop:
	sudo docker stop cucalc
rm:
	sudo docker rm cucalc

