#! /bin/bash

# use this file if it's there
PREFERRED_SOUND_FILE="$HOME/Sounds/Ping.wav"

# if the above one isn't there, we'll search for this one using locate
FALLBACK_SOUND_FILE="Ping.wav"

PLAY_CMD="play"
PING_CMD="ping -q -c 1 -W 2"


# validate invocation
if [ $# -ne 1 ] && [ $# -ne 2 ]; then
    echo "usage: $(basename ${0}) <host>" ; echo 
    exit 1
fi

# figure out a sound file to use
soundFile=$PREFERRED_SOUND_FILE
if [ ! -f "$soundFile" ]; then
    echo "$soundFile not found, will try to find $FALLBACK_SOUND_FILE"
    soundFile=$(locate -q -n 1 $FALLBACK_SOUND_FILE)
fi
if [ ! -f "$soundFile" ]; then
    echo "coundn't find $FALLBACK_SOUND_FILE either, bailing out"
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
        $PLAY_CMD "$soundFile" &> /dev/null || break;
    else
        echo -n "."
    fi
    sleep $interval || break
done
