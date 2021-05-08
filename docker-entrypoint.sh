#!/bin/sh
set -e

if [ -z "${PASSWORD}" ]; then
    PASSWORD=`tr -dc A-Za-z0-9 </dev/urandom | head -c 16`
fi

if [ ! -z "${OBFS}" ]; then
    if [ "${OBFS}" == "http" ]; then
        PLUGIN="obfs-server"
        PLUGIN_OPTS="obfs=http"
    fi

    if [ "${OBFS}" == "tls" ]; then
        PLUGIN="obfs-server"
        PLUGIN_OPTS="obfs=tls"
    fi

    if [ "${OBFS}" == "ws" ]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server"
    fi

    if [ "${OBFS}" == "wss" ]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server;tls"
    fi

    if [ "${OBFS}" == "quic" ]; then
        PLUGIN="v2ray-plugin"
        PLUGIN_OPTS="server;mode=quic"
    fi
fi

SERVER_PLUGIN=""
if [ ! -z "${PLUGIN}" ]; then
    SERVER_PLUGIN="--plugin ${PLUGIN} --plugin-opts ${PLUGIN_OPTS}"
fi

echo ""
echo -e "\033[32m [!] Server Port:\033[0m ${SERVER_PORT}"
echo -e "\033[32m [!] Encryption Method:\033[0m ${METHOD}"
echo -e "\033[32m [!] Password:\033[0m ${PASSWORD}"
echo -e "\033[32m [!] DNS Server:\033[0m ${DNS}"
if [ ! -z "${OBFS}" ]; then
    echo -e "\033[32m [!] Plugin:\033[0m ${OBFS}"
fi
echo -e '\033[32m [+] Enjoy :)\033[0m'
echo ""

ss-server \
-s ${SERVER_ADDR} \
-p ${SERVER_PORT} \
-k ${PASSWORD} \
-m ${METHOD} \
-t ${TIMEOUT} \
-d ${DNS} \
-u \
--fast-open \
--reuse-port \
--no-delay \
${SERVER_PLUGIN} \
"$@"
