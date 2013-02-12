#!/bin/bash
PREFIX=${PREFIX:-/etc/websafe/hostbeat}
CONFIG=${CONFIG:-$PREFIX/hostbeat.local.conf}
SERVER_URL=${SERVER_URL:-http://hostbeat.websafe.pl}
SERVER_PATH=${SERVER_PATH:-/}
CMD_WGET=${CMD_WGET:-wget}
CMD_GREP=${CMD_GREP:-grep}
CMD_SED=${CMD_SED:-sed}
NETWORK_IFACE=${NETWORK_IFACE:-eth0}
##
##
##
if [ -r ${CONFIG} ]; then
    source ${PREFIX}/hostbeat.local.conf;
fi
##
## http://stackoverflow.com/a/10660730
## @author http://stackoverflow.com/users/912236/orwellophile
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
##
##
##
loadavgcontent=$(cat /proc/loadavg)
loadavgencoded=$(rawurlencode "${loadavgcontent}")
uptimecontent=$(cat /proc/uptime)
uptimeencoded=$(rawurlencode "${uptimecontent}")
#hostnameresult=$(hostname -f)
hostnamehash=$(hostname -f | sha1sum | cut -d' ' -f1)
timestampresult=$(date "+%s")
##
##
##
netifacecontent=$(${CMD_GREP} "${NETWORK_IFACE}:" /proc/net/dev \
    | ${CMD_SED} -e "s/^[ ]\+//g" \
	-e "s/[ ]\+/:/g" \
	-e "s/^${NETWORK_IFACE}\://g" \
	-e "s/^\://g"
)
#echo $netifacecontent
netifaceencoded=$(rawurlencode "${netifacecontent}")
#uptimeresult=$(uptime)
#uptimeencoded=$(rawurlencode "${uptimeresult}")
#dfresult=$(df -TH)
#dfencoded=$(rawurlencode "${dfresult}")
uri="?h=${hostnamehash}&t=${timestampresult}&u=${uptimeencoded}&l=${loadavgencoded}&n=${netifaceencoded}"
##
##
##
${CMD_WGET} --no-check-certificate -q -O /dev/null ${SERVER_URL}${SERVER_PATH}${uri}
