FROM openvidu/openvidu-server-kms:2.5.0
MAINTAINER xroger88@gmail.com

#if changed by myself, then copy it
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy kurento conf file to enable secure port
COPY kurento.conf.json /etc/kurento/kurento.conf.json
COPY defaultCertificate.pem /etc/kurento/defaultCertificate.pem

# Set the working directory to /app
WORKDIR /app
COPY ./app /app


EXPOSE 9091
# openvidu server port
EXPOSE 4443
# non-secure KMS port
EXPOSE 8888
# secure KMS port
EXPOSE 8443 
# simple http server serving resources (/web) as file server, secure nats-websocket-gw2 (/nats)
EXPOSE 8910
# nats server port
EXPOSE 4222

# Exec supervisord
CMD ["/usr/bin/supervisord"]