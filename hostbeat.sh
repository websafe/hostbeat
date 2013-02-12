#!/bin/bash

PREFIX=${PREFIX:-/etc/websafe/hostbeat}
CONFIG=${CONFIG:-$PREFIX/hostbeat.local.conf}
SERVER_URL=${SERVER_URL:-http://hostbeat.websafe.pl}
SERVER_PATH=${SERVER_PATH:-/}
CMD_WGET=${CMD_WGET:-wget}
NETWORK_IFACE=${NETWORK_IFACE:-eth0}

if [ ! -r ${CONFIG} ]; then
    echo "'${CONFIG}' not found."
    exit 1
else
    source ${PREFIX}/hostbeat.local.conf;
fi

# http://stackoverflow.com/a/10660730
rawurlencode() {
    local string="${1}"
    local strlen=${#string}
    local encoded=""
    for (( pos=0 ; pos<strlen ; pos++ )); do
        c=${string:$pos:1}
        case "$c" in
            [-_.~a-zA-Z0-9] )
                o="${c}" ;;
            * )
                printf -v o '%%%02x' "'$c"
        esac
        encoded+="${o}"
    done
    echo "${encoded}"    # You can either set a return variable (FASTER) 
}

loadavgcontent=$(cat /proc/loadavg)
loadavgencoded=$(rawurlencode "${loadavgcontent}")
uptimecontent=$(cat /proc/uptime)
uptimeencoded=$(rawurlencode "${uptimecontent}")
#hostnameresult=$(hostname -f)
hostnamehash=$(hostname -f | sha1sum | cut -d' ' -f1)
timestampresult=$(date "+%s")
#uptimeresult=$(uptime)
#uptimeencoded=$(rawurlencode "${uptimeresult}")
#dfresult=$(df -TH)
#dfencoded=$(rawurlencode "${dfresult}")
uri="?h=${hostnamehash}&t=${timestampresult}&u=${uptimeencoded}&l=${loadavgencoded}"

${CMD_WGET} -q -O /dev/null ${SERVER_URL}${SERVER_PATH}${uri}
