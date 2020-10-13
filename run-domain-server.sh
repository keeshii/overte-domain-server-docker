#! /bin/bash
# Start the domain-server with persistant data in local dir
# Invocation: ./run-domain-server {metaverse_server_url} {ice_server_location}
#   or the metaverse-server and ice-server can be set with environment
#      variables METAVERSE_URL and ICE_SERVER

export ENV_METAVERSE_URL=${METAVERSE_URL:-https://metaverse.vircadia.com/live}
if [[ ! -z "$1" ]] ; then
    ENV_METAVERSE_URL=$1
fi
export ENV_ICE_SERVER=${ICE_SERVER:-ice.vircadia.com}
if [[ ! -z "$2" ]] ; then
    ENV_ICE_SERVER=$1
fi

BASE="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd )"

cd "${BASE}"

DVERSION=latest

# Create local directories that are mounted from the Docker container
# Permission is set to 777 since the container runs its own UID:GID
mkdir -p ${BASE}/server-dotlocal
chmod 777 ${BASE}/server-dotlocal
mkdir -p ${BASE}/server-logs
chmod 777 ${BASE}/server-logs

docker run \
        -d \
        --restart=unless-stopped \
        --name=domainserver \
        -p 40100-40102:40100-40102 -p 40100-40102:40100-40102/udp \
        -p 48000-48009:48000-48009/udp \
        -e METAVERSE_URL=$ENV_METAVERSE_URL \
        -e ICE_SERVER=$ENV_ICE_SERVER \
        --volume ${BASE}/server-dotlocal:/home/cadia/.local \
        --volume ${BASE}/server-logs:/home/cadia/logs \
        misterblue/vircadia-domain-server:${DVERSION}
