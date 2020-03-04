FROM alpine:3.11
RUN apk update
RUN apk add git ruby curl python python-dev py-pip musl-dev libffi-dev gcc \
    linux-headers openssl-dev openssl bash
RUN pip install letsencrypt
RUN git clone https://github.com/lukas2511/dehydrated.git
ADD manual_hook.rb dehydrated/hooks/manual/manual_hook.rb
ADD start /opt/start
RUN ./dehydrated/dehydrated --register --accept-terms
CMD /opt/start
