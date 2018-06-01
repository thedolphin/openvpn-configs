#!/bin/bash

cn=${1:?CN must be specified}
key="${cn}.key"
csr="${cn}.csr"
crt="${cn}.crt"

if [ -e "$crt" ]; then
    echo "file $crt already exists"
    exit
fi

openssl genrsa -out "$key" 2048
openssl req -new -key "$key" -out "$csr" -subj "/CN=${cn}"
openssl x509 -req -in "$csr" -CA OpenVPN-CA.crt -CAkey OpenVPN-CA.key -CAcreateserial -out "$crt" -days 3650

tar -czf "${cn}.tar.gz" -C .. vpnclient.conf ssl/OpenVPN-CA.crt "ssl/${cn}.crt" "ssl/${cn}.key"
