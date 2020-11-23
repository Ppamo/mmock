FROM alpine:3.9
LABEL maintainer="pablo@ppamo.cl"

VOLUME /config
EXPOSE 8082 8083 8084

RUN apk --no-cache add \
    ca-certificates curl && \
    mkdir /tls && chown 1001.1001 /config && chown 1001.1001 /tls

USER 1001

COPY tls/server.crt /tls/server.crt
COPY tls/server.key /tls/server.key
COPY mmock /usr/local/bin/mmock

ENTRYPOINT ["mmock", "-config-path", "/config", "-tls-path", "/tls"]
CMD ["-server-ip", "0.0.0.0", "-console-ip", "0.0.0.0"]
HEALTHCHECK --interval=30s \
	--timeout=3s \
	--start-period=3s \
	--retries=2 \
	CMD curl -f http://localhost:8082 || exit 1
