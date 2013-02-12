#!/bin/bash
PREFIX=${PREFIX:-/etc/websafe/hostbeat}
CONFIG=${CONFIG:-$PREFIX/hostbeat.local.conf}
SERVER_URL=${SERVER_URL:-http://hostbeat.websafe.pl}
SERVER_PATH=${SERVER_PATH:-/}
CMD_WGET=${CMD_WGET:-wget}
CMD_GREP=${CMD_GREP:-grep}
CMD_SED=${CMD_SED:-sed}
CMD_HOSTNAME=${CMD_HOSTNAME:-hostname}
CMD_DATE=${CMD_DATE:-date}
CMD_SHA1SUM=${CMD_SHA1SUM:-sha1sum}
CMD_CUT=${CMD_CUT:-cut}
CMD_CAT=${CMD_CAT:-cat}
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
    echo "${encoded}"
}
##
##
##
loadavgcontent=$(${CMD_CAT} /proc/loadavg)
loadavgencoded=$(rawurlencode "${loadavgcontent}")
uptimecontent=$(${CMD_CAT} /proc/uptime)
uptimeencoded=$(rawurlencode "${uptimecontent}")
#hostnameresult=$(hostname -f)
hostnamehash=$(${CMD_HOSTNAME} -f | ${CMD_SHA1SUM} | ${CMD_CUT} -d' ' -f1)
timestampresult=$(${CMD_DATE} "+%s")
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
uri="?h=${hostnamehash}&t=${timestampresult}&u=${uptimeencoded}&l=${loadavgencoded}&n=${netifaceencoded}"
##
##
##
${CMD_WGET} --no-check-certificate -q -O /dev/null ${SERVER_URL}${SERVER_PATH}${uri}
