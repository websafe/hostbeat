#!/bin/sh
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
    REPLY="${encoded}"   #+or echo the result (EASIER)... or both... :p
}
#hostnameresult=$(hostname -f)
hostnamehash=$(hostname -f | sha1sum | cut -d' ' -f1)
timestampresult=$(date "+%s")
uptimeresult=$(uptime)
uptimeencoded=$(rawurlencode "${uptimeresult}")
dfresult=$(df -TH)
dfencoded=$(rawurlencode "${dfresult}")
uri="?h=${hostnamehash}&amp;t=${timestampresult}&amp;u=${uptimeencoded}"

wget -q -O /dev/null http://hostbeat.websafe.pl/${uri}
