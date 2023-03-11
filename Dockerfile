# Start by building the application.
FROM golang:1.20 as build

WORKDIR /usr/src/wireproxy
COPY . .

RUN CGO_ENABLED=0 go build ./cmd/wireproxy

# Now copy it into our base image.
FROM gcr.io/distroless/static-debian11:nonroot
COPY --from=build /usr/src/wireproxy/wireproxy /usr/bin/wireproxy

VOLUME [ "/etc/wireproxy"]
ENTRYPOINT [ "/usr/bin/wireproxy" ]
CMD [ "--config", "/etc/wireproxy/config" ]

LABEL org.opencontainers.image.title wireproxy
LABEL org.opencontainers.image.description "Wireguard client that exposes itself as a socks5 proxy"
LABEL org.opencontainers.image.licenses ISC
