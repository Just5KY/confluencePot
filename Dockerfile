FROM golang:bullseye

RUN apt-get update \
    apt-get install openssl

WORKDIR /app

COPY . .

RUN openssl genrsa -des3 -passout pass:x -out keypair.key 2048 \
    openssl rsa -passin pass:x -in keypair.key -out server.key  \
    openssl req -new -key server.key -out server.csr    \
    openssl x509 -req -days 365 -in server.csr -signkey server.key -out server.crt

RUN go build confluencePot.go

ENTRYPOINT ["./confluencePot"]