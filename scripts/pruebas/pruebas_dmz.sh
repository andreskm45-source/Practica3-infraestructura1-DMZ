#!/bin/bash
echo "Gateway de la DMZ"
ping -c 3 10.7.84.129
echo "Endpoints de actualizacion (debe responder)"
curl -4 -I --max-time 10 http://archive.ubuntu.com
echo "Internet no permitido (debe fallar)"
curl -4 -I --max-time 10 https://www.google.com || true
echo "Fuga hacia la VLAN 10 (debe fallar)"
ping -c 3 -W 2 10.7.84.2 || true
