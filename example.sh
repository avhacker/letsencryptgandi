# Specify api key, domain, and email, the cert file will be output to /tmp/certs
# Replace the path if necessary.
docker run -e DOMAIN=host.example.com -e EMAIL=someone@@gmail.com -e GANDI_API_KEY=xxxxxxxxxxxx -it --rm --name certbot -v /tmp/certs:/certs letsencryptgandi:0.2

