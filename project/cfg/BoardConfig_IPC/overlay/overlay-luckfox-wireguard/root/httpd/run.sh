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
  if [ ! -f ${basedir}/httpd.conf ]; then
    touch ${basedir}/httpd.conf
  fi
  httpd -f -c ${basedir}/httpd.conf -h ${basedir}/www
  sleep 1
done
