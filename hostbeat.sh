#!/bin/bash
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

wget -q -O /dev/null http://hostbeat.websafe.pl/${uri}
#wget  http://hostbeat.websafe.pl/${uri}
