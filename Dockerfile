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
COPY --from=build /go/src/github.com/st3fan/dovecot-xaps-daemon/xapsd /
ENTRYPOINT ["/xapsd" , "-key=/config/key.pem", "-certificate=/config/certificate.pem", "-database=/config/xapsd.json", "-socket=/sockets/xapsd.sock", "-delayCheckInterval=10", "-delayTime=20"]