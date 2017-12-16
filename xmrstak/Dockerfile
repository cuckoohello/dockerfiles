FROM alpine:edge

ENV XMRSTAK_VERSION 2.1.0

RUN apk add --update --no-cache tzdata && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/edge/testing' >> /etc/apk/repositories && \
    apk add --update --no-cache libmicrohttpd openssl hwloc && \
    apk add --update --no-cache --virtual .build-deps cmake gcc make g++ musl-dev libmicrohttpd-dev openssl-dev hwloc-dev curl tar ca-certificates && \
    curl -fsSL https://github.com/fireice-uk/xmr-stak/archive/v${XMRSTAK_VERSION}.tar.gz | tar xzv -C /tmp/ && \
    mkdir -p /tmp/xmr-stak-${XMRSTAK_VERSION}/build && cd /tmp/xmr-stak-${XMRSTAK_VERSION}/build && \
    cmake -DXMR-STAK_COMPILE=native -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF -DCMAKE_LINK_STATIC=ON .. && make && \
    strip bin/xmr-stak && cp bin/xmr-stak /usr/bin/ && cd / && rm -rf /tmp/xmr-stak-${XMRSTAK_VERSION} && \
    apk del .build-deps
