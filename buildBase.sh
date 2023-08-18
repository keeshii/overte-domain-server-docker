#! /bin/bash
# Build the base Docker images. This base images is the support
#    libraries (Qt, ...) and the Vircadia server apps (domain-server, ...).

# Set the environment variable TAG to the github tag to pull.
export BUILDREPO=${VIRCADIA_REPO:-https://github.com/overte-org/overte}
export BUILDTAG=${VIRCADIA_TAG:-master}

echo "=== Building ${BUILDREPO}:${BUILDTAG}"

docker build -f Dockerfile-base \
        --build-arg REPO=${BUILDREPO} \
        --build-arg TAG=${BUILDTAG} \
        -t overte-server-build-base . | tee ./out.buildBase 2>&1
