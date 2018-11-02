
build:
	sudo docker build -t my_ms .

docker-run-net:
	sudo docker run --name=my_ms --net=host --rm -it  -e openvidu.secret=ok -e openvidu.publicurl=https://35.235.125.30:4443/ -e KMS_STUN_IP=35.235.125.30 -e KMS_STUN_PORT=3478 my_ms

docker-run:
	sudo docker run --name=my_ms --rm -it -p 4443:4443 -p 8433:8433 -p 4222:4222 -p 8910:8910 -e openvidu.publicurl=https://35.235.125.30:4443/ -e KMS_STUN_IP=35.235.125.30 -e KMS_STUN_PORT=3478 my_ms

docker-run-bash:
	sudo docker run --name=my_ms --rm -it -p 4443:4443 -p 8433:8433 -p 4222:4222 -p 8910:8910 -e openvidu.publicurl=https://35.235.125.30:4443/ -e KMS_STUN_IP=35.235.125.30 -e KMS_STUN_PORT=3478 my_ms bash

# for pushing the image to repository in docker hub
push:
	sudo docker tag my_ms xroger88/justforfun:my_ms
	sudo docker image push xroger88/justforfun:my_ms

