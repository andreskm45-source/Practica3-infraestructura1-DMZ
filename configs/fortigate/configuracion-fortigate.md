# Configuración del FortiGate por GUI

> FortiOS 7.0.3. Toda la configuración y demostración del FortiGate se realiza por GUI.

## Interfaces y direccionamiento

| Interfaz | Dirección / función |
|---|---|
| port1 | WAN/ISP - 192.168.20.154/24 |
| port2 | Enlace hacia SW2; transporta VLAN 10 y VLAN 20 |
| VLAN10 | 10.7.84.1/25 |
| Vlan20 | 25.7.84.1/25 |
| port3 | DMZ - 10.7.84.129/28 |

### DHCP
- VLAN 10: 10.7.84.2 - 10.7.84.126
- VLAN 20: 25.7.84.2 - 25.7.84.126

## DNS
El FortiGate funciona como servidor DNS recursivo para VLAN10, Vlan20 y port3. Los servidores de la DMZ utilizan 10.7.84.129 como DNS.

## Objetos de direcciones
- NET_VLAN10: 10.7.84.0/25
- NET_VLAN20: 25.7.84.0/25
- NET_DMZ: 10.7.84.128/28
- SRV_INVENTARIO: 10.7.84.130/32
- GRP_LAN_USUARIOS: NET_VLAN10 + NET_VLAN20
- GRP_UPDATES: archive.ubuntu.com, security.ubuntu.com, ntp.ubuntu.com y ubuntu.com

## Perfil Web Filter
Perfil: `WF_BLOQUEO_INVENTARIO`.

Mensaje mostrado al usuario:

> Violación de política de seguridad: su VLAN no tiene permiso para acceder al Sistema de Inventario.

## Políticas de firewall

| # | Política | Interfaces | Servicio | Acción | NAT |
|---|---|---|---|---|---|
| 1 | V10-INV-HTTP-BLOQUEO | VLAN10 > port3 | HTTP | ACCEPT + Web Filter | No |
| 2 | V10-INV-DENY | VLAN10 > port3 | ALL | DENY | - |
| 3 | V10-SSH-DENY | VLAN10 > port3 | SSH | DENY | - |
| 4 | V20-SSH-DMZ | Vlan20 > port3 | SSH | ACCEPT | No |
| 5 | DMZ-UPDATES | port3 > port1 | HTTP, HTTPS, NTP | ACCEPT | Sí |
| 6 | DMZ-INTERNET-DENY | port3 > port1 | ALL | DENY | - |
| 7 | LAN-WEB-DMZ | VLAN10/Vlan20 > port3 | HTTP, HTTPS | ACCEPT | No |
| 8 | DMZ-A-LAN-DENY | port3 > VLAN10/Vlan20 | ALL | DENY | - |
| 9 | LAN-INTERNET | VLAN10/Vlan20 > port1 | ALL | ACCEPT | Sí |

El orden de las políticas es importante: las reglas específicas de bloqueo preceden a las reglas generales de permiso.
