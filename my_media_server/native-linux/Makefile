start:
	sudo service redis-server restart
	sudo service coturn restart
	sudo service kurento-media-server restart
	java -jar -Dopenvidu.secret=MY_SECRET -Dopenvidu.publicurl=https://35.235.125.30:4443/ openvidu-server-2.6.0.jar &
	./gnatsd &
	./nats-websocket-gw2 --no-origin-check --trace &

stop:
	sudo service redis-server stop
	sudo service coturn stop
	sudo service kurento-media-server stop
	echo "kill java openvidu server"
	echo "kill gnatsd"
	echo "kill nats-websocket-gw2"

test:
	PID=`ps ax | grep nats-websocket-gw2 | line | awk '{ print $1 }'`
	echo $PID
