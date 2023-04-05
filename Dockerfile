FROM alpine:3.11
RUN apk add certbot curl
ADD authenticator.sh /etc/letsencrypt/gandi/authenticator.sh
ADD start.sh /start.sh
CMD /start.sh
