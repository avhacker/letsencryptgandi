# Specify api key, domain, and ssl host, the cert file will be output to /tmp/certs
# Replace the path if necessary.
docker run -it -e GANDI_API_KEY=apiapiapiapiapiapiapiapi \
-e GANDI_DOMAIN=benusdt.com \
-e SSL_HOST=test \
-v /tmp/certs:/dehydrated/certs/ \
letsencryptgandi

docker run -it -e GANDI_API_KEY=apiapiapiapiapiapiapiapi \
-e GANDI_DOMAIN=benusdt.com \
-e SSL_HOST="" \
-v /tmp/certs:/dehydrated/certs/ \
letsencryptgandi

