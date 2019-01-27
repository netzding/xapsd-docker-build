FROM golang:alpine AS build

RUN apk --update add gcc git
RUN go get -d -v github.com/st3fan/dovecot-xaps-daemon
ENV CGO_ENABLED 0
ENV GOARCH amd64
ENV GOOS linux
WORKDIR /go/src/github.com/st3fan/dovecot-xaps-daemon
RUN env
RUN go build -ldflags "-s -w" -o xapsd

FROM scratch
ENV KEY_PATH /config/key.pem
ENV CERT_PATH /config/certificate.pem
ENV DB_PATH /config/xapsd.json
ENV SOCKET_PATH /sockets/xapsd.sock
ENV DELAY_CHECK_INTERVAL 20
ENV DELAY_TIME 30
COPY --from=build /go/src/github.com/st3fan/dovecot-xaps-daemon/xapsd /
ENTRYPOINT ["/xapsd" , "-key=${KEY_PATH}", "-certificate=${CERT_PATH}", "-database=${DB_PATH}", "-socket=${SOCKET_PATH}", "-delayCheckInterval=${DELAY_CHECK_INTERVAL}", "-delayTime=${DELAY_TIME}"]