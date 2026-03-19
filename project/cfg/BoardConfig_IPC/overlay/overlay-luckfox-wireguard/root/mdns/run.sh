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

while [ 1 -eq 1 ]
do
  if [ ! -z $(which mdns) ]; then
    timeout 30s mdns --hostname wireguard --service $(cat /proc/sys/kernel/random/uuid).local
  else
    sleep 1
  fi
done
