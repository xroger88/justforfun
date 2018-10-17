FROM openvidu/openvidu-server-kms:2.5.0
MAINTAINER xroger88@gmail.com

#if changed by myself, then copy it
#COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# copy kurento conf file to enable secure port
COPY kurento.conf.json /etc/kurento/kurento.conf.json
COPY defaultCertificate.pem /etc/kurento/defaultCertificate.pem

EXPOSE 9091
# openvidu server port
EXPOSE 4443
# non-secure KMS port
EXPOSE 8888
# secure KMS port
EXPOSE 8443 

# Exec supervisord
CMD ["/usr/bin/supervisord"]