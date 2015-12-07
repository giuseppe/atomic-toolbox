#!/bin/bash

set -e

if test $1 == "--install"; then
    INDEX=/opt/hostapps/`echo $3 | tr '/' '_'`
    REV=`ostree rev-parse $3`

    if test $REV == `cat $INDEX`; then
        exit 0
    fi
    
    if test -e $INDEX && test -e /opt/hostapps/`cat $INDEX`; then
        rm -rf /opt/hostapps/`cat $INDEX`
    fi
        
    ostree pull $2 $3
    mkdir -p /var/run/hostapps /opt/hostapps/

    if test \! -e /opt/hostapps/$REV; then
        ostree checkout --fsync=no $REV /opt/hostapps/$REV
    fi

    # Be sure /tmp doesn't exist
    rm -rf /opt/hostapps/$REV/tmp
    echo $REV > $INDEX
    exit 0
fi

REV=$(ostree rev-parse $1)

shift
CMD="cd $(pwd); $@"
systemd-nspawn -q \
    --directory="/opt/hostapps/$REV" \
    --capability=all \
    --share-system \
    --overlay-ro=/usr:/opt/hostapps/$REV/usr:/usr \
    --bind=/run:/run \
    --bind=/etc:/etc \
    --bind=/var:/var \
    --bind=/sysroot:/sysroot \
    /bin/sh -c "$CMD"
