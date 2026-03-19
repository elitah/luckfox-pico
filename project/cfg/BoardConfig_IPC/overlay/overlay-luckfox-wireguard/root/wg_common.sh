#!/bin/sh

wg_reload() {
  if [ ! -z ${1} ] && [ -f /etc/wireguard/${1}.conf ]; then
    wg-quick down ${1} > /dev/null 2>&1

    iptables -F; iptables -t nat -F; iptables -t mangle -F; iptables -X; iptables -t nat -X; iptables -t mangle -X
    ip6tables -F; ip6tables -t nat -F; ip6tables -t mangle -F; ip6tables -X; ip6tables -t nat -X; ip6tables -t mangle -X

    iptables -P INPUT ACCEPT
    iptables -P FORWARD DROP
    iptables -P OUTPUT ACCEPT

    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    iptables -A FORWARD -i ${1} -o eth0 -j ACCEPT
    iptables -A FORWARD -i eth0 -o ${1} -m state --state ESTABLISHED,RELATED -j ACCEPT

    ip6tables -P INPUT DROP
    ip6tables -P FORWARD DROP
    ip6tables -P OUTPUT ACCEPT
    ip6tables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
    ip6tables -A INPUT -i eth0 -p ipv6-icmp -j ACCEPT

    wg-quick up ${1} > /dev/null 2>&1

    result=${?}

    sysctl -w net.ipv4.ip_forward=1

    rm -rf /tmp/${1}.status

    return ${result}
  fi
  return -1
}
