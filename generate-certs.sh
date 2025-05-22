#!/bin/bash
set -e
mkdir -p certs && cd certs

# Create CA
openssl genrsa -out ca.key 2048
openssl req -x509 -new -nodes -key ca.key -sha256 -days 3650 -out ca.pem -subj "/CN=LocalDevCA"

# Server cert
openssl genrsa -out server.key 2048
openssl req -new -key server.key -out server.csr -subj "/CN=localhost"
openssl x509 -req -in server.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out server.crt -days 825 -sha256

# Client cert
openssl genrsa -out client.key 2048
openssl req -new -key client.key -out client.csr -subj "/CN=devuser"
openssl x509 -req -in client.csr -CA ca.pem -CAkey ca.key -CAcreateserial -out client.crt -days 825 -sha256

# Bundle into a .p12 file
openssl pkcs12 -export \
  -inkey client.key \
  -in client.crt \
  -certfile ca.pem \
  -out client.p12 \
  -name "devuser" \
  -passout pass:1234
