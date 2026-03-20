#!/bin/sh

basedir=`readlink -f ${0}`

if [ -z ${basedir} ]; then
  exit
fi

basedir=`dirname ${basedir}`

if [ -z ${basedir} ]; then
  exit
fi

echo ''
echo ''
echo ''
echo 'execute path: '${basedir}
echo ''

cd ${basedir}

if [ -f /root/wg_common.sh ]; then
  . /root/wg_common.sh
fi

if [ ! -f /etc/wireguard/wg0.conf ]; then
  cat > /etc/wireguard/wg0.conf << EOF
[Interface]
PrivateKey = $(wg genkey)
Address = 192.168.1.1/32
MTU = 1280
EOF
fi

wg_reload wg0 > /dev/null 2>&1

if [ ! -z ${STY} ]; then
  screen -S "${STY}" -X quit > /dev/null 2>&1
else
  kill $(cat /proc/${PPID}/stat | awk '{print $4}')
fi
