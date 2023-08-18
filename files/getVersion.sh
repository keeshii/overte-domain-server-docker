#! /bin/bash
# Copy out the JSON version information or just the one version file
# Invocation: getVersion.sh {tagName}
# If 'tagName' is specified, only that version tag value is output

VERFILE=/root/Overte/version/VERSION.json

# Get optional tag and remove any special characters
TAG=${1//[\\\|\<\>]/}

if [[ ! -z "$TAG" ]] ; then
    FLAG=$(grep "$TAG" "$VERFILE")
    if [[ ! -z "$FLAG" ]] ; then
        TAGFILE=/root/Overte/version/$TAG
        if [[ -f "$TAGFILE" ]] ; then
            cat "$TAGFILE"
        fi
    fi
else
    cat /root/Overte/version/VERSION.json
fi

