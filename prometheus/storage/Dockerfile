FROM golang:1-alpine AS build
RUN apk add git binutils && go get github.com/prometheus/prometheus/documentation/examples/remote_storage/remote_storage_adapter && strip /go/bin/remote_storage_adapter

FROM alpine:3.9
COPY --from=build /go/bin/remote_storage_adapter /usr/local/bin/

EXPOSE      9201
ENTRYPOINT  [ "/usr/local/bin/remote_storage_adapter" ]
