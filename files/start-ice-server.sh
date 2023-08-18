#! /bin/bash

export HIFI_METAVERSE_URL=${METAVERSE_URL:-https://mv.overte.org/server}

LOGDIR=/home/cadia/logs
mkdir -p "${LOGDIR}"

LOGDATE=$(date --utc "+%Y%m%d.%H%M")
LOGFILE=${LOGDIR}/ice-server-${LOGDATE}

RUNDIR=/root/Overte/install_master

cd "${RUNDIR}"

./run_ice-server --url ${HIFI_METAVERSE_URL} >> "${LOGFILE}.log" 2>&1
