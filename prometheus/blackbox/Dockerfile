FROM golang:1-alpine AS build
RUN apk add git binutils && go get github.com/prometheus/blackbox_exporter && strip /go/bin/blackbox_exporter
FROM alpine:3.9
COPY --from=build /go/bin/blackbox_exporter /usr/local/bin/
COPY --from=build /go/src/github.com/prometheus/blackbox_exporter/blackbox.yml /etc/blackbox_exporter/config.yml

EXPOSE      9115
ENTRYPOINT  [ "/usr/local/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
