#! /bin/bash

PING_CMD="ping -q -c 1 -W 2"


# validate invocation
if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    echo "usage: $(basename ${0}) <host>" ; echo 
    exit 1
fi


host=$1
interval=$2 # seconds
if [ "Z$interval" == "Z" ]; then
    interval=1
fi

# ok, go
while [ true ]; do 
    $PING_CMD $host > /dev/null

    # ping successful --> returns 0
    if [ $? -eq 0 ]; then
        echo -n "*"
    else
        echo -n "."
    fi
    sleep $interval || break
done
