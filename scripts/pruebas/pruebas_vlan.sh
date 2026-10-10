#!/bin/bash
GW="${1:?Uso: pruebas_vlan.sh IP_GATEWAY_DE_LA_VLAN}"
echo "Gateway"
ping -c 3 "$GW"
echo "Internet por IP"
ping -c 3 8.8.8.8
echo "Sistema de Caja"
curl -s --max-time 10 http://10.7.84.131
echo "Sistema de Inventario"
curl -s --max-time 10 http://10.7.84.130
echo "SSH al Inventario"
ssh -o ConnectTimeout=5 rafael@10.7.84.130 exit
