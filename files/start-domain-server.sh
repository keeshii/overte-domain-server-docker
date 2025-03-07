#! /bin/bash

export HIFI_METAVERSE_URL=${METAVERSE_URL:-https://mv.overte.org/server}
export ICE_SERVER_URL=${ICE_SERVER:-ice.overte.org:7337}

# If running multiple domain-servers on one computer, the ports must be different.
# The following code creates blocks of ports for each domain-server instance.
# Instance zero is the normal default ports.
# There can be up to 9 instances.
# Note that the value can be passed in from the 'docker run' parameters
if [[ -z "$INSTANCE" ]] ; then
    export INSTANCE=0
fi

LOGDIR=/home/cadia/logs
mkdir -p "${LOGDIR}"

LOGDATE=$(date --utc "+%Y%m%d.%H%M")

if [ -z "$DISABLE_LOGS" ] || [ "$DISABLE_LOGS" = "0" ] ; then
  LOGFILE=${LOGDIR}/domain-server-${LOGDATE}-A.log
  ALOGFILE=${LOGDIR}/assignment-${LOGDATE}.log
  ILOGFILE=${LOGDIR}/ice-server-${LOGDATE}.log
else
  LOGFILE=/dev/null
  ALOGFILE=/dev/null
  ILOGFILE=/dev/null
fi

RUNDIR=/root/Overte/install_master

DOMAIN_SERVER_BASE=$(( 40100 + $INSTANCE * 10 ))
ASSIGNMENT_BASE=$(( 48000 + $INSTANCE * 10 ))

# Each of the assignment-clients point back to the domain-server to make connections.
DOMAIN_SERVER_PORT=$(( $DOMAIN_SERVER_BASE + 2 ))

(
    echo "Starting domain-server: $(date)"
    echo "   HIFI_METAVERSE_URL=${HIFI_METAVERSE_URL}"
    echo "   ICE_SERVER_URL=${ICE_SERVER_URL}"
    echo "   INSTANCE=${INSTANCE}"
    echo "   DOMAIN_SERVER_PORT=${DOMAIN_SERVER_PORT}"
    echo "   DOMAIN_SERVER_BASE=${DOMAIN_SERVER_BASE}"
    echo "   ASSIGNMENT_BASE=${ASSIGNMENT_BASE}"
) >> "${LOGFILE}"

cd "${RUNDIR}"

#./run_assignment-client -t 0 -p $(( $ASSIGNMENT_BASE + 0 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-0.log" 2>&1 &
#./run_assignment-client -t 1 -p $(( $ASSIGNMENT_BASE + 1 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-1.log" 2>&1 &
#./run_assignment-client -t 6 -p $(( $ASSIGNMENT_BASE + 6 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-6.log" 2>&1 &
#./run_assignment-client -t 3 -p $(( $ASSIGNMENT_BASE + 3 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-3.log" 2>&1 &
#./run_assignment-client -t 5 -p $(( $ASSIGNMENT_BASE + 5 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-5.log" 2>&1 &
#./run_assignment-client -t 4 -p $(( $ASSIGNMENT_BASE + 4 )) --server-port ${DOMAIN_SERVER_PORT} >> "${ALOGFILE}-4.log" 2>&1 &
#./run_assignment-client -t 2 -p $(( $ASSIGNMENT_BASE + 2 )) --server-port ${DOMAIN_SERVER_PORT} --max 60 >> "${ALOGFILE}-2.log" 2>&1 &

if [ -z "$DISABLE_ICE_SERVER" ] || [ "$DISABLE_ICE_SERVER" = "0" ] ; then
  ./run_ice-server --url ${HIFI_METAVERSE_URL} >> "${ILOGFILE}" 2>&1 &
  sleep 1
fi

./run_assignment-client -p $ASSIGNMENT_BASE --server-port ${DOMAIN_SERVER_PORT} --max 20 >> "${ALOGFILE}" 2>&1 &

sleep 3

./run_domain-server -i ${ICE_SERVER_URL} >> "${LOGFILE}" 2>&1
