#!/bin/sh

if [ -z ${0} ]; then
  exit
fi

if [ -z ${1} ]; then
  exit
fi

if [ -z ${2} ]; then
  exit
fi

if [ ! -f ${2} ]; then
  exit
fi

sudo whoami > /dev/null 2>&1

SHELLPATH=${SHELL}

if [ -z ${SHELLPATH} ] || [ ! -f ${SHELLPATH} ] || [ ! -x ${SHELLPATH} ]; then
  SHELLPATH=`which bash`
fi

if [ -z ${SHELLPATH} ] || [ ! -f ${SHELLPATH} ] || [ ! -x ${SHELLPATH} ]; then
  SHELLPATH=/bin/sh
fi

SESSION=${1}_$$
SCRIPTCMD=`readlink -f ${2}`
SCRIPTDIR=`dirname ${SCRIPTCMD}`

if [ ! -x ${SHELLPATH} ]; then
  exit
fi

if [ -z ${SESSION} ]; then
  exit
fi

if [ -z ${SCRIPTCMD} ]; then
  exit
fi

echo 'SHELL PATH: '${SHELLPATH}

if [ -z `which screen` ]; then
  echo "Install 'screen' first"
  echo "Ubuntu: apt-get install -y screen"
  echo "CentOS: yum install -y screen"
else
  screen -dmS ${SESSION} -s "${SHELLPATH}"
  sleep 1
  screen -x -S ${SESSION} -p 0 -X stuff "cd ${SCRIPTDIR}"
  screen -x -S ${SESSION} -p 0 -X stuff '\n'
  screen -x -S ${SESSION} -p 0 -X stuff "${SCRIPTCMD}"
  screen -x -S ${SESSION} -p 0 -X stuff '\n'
fi
