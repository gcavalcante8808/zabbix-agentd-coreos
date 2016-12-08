#!/bin/bash
set -e

if [ ! -d "/opt/bin" ]; then
    mkdir -p /opt/bin
fi

echo "Downloading Zabbix Agentd ${ZBX_VERSION}"
wget https://github.com/gcavalcante8808/zabbix-agentd-coreos/releases/download/$ZBX_VERSION/zabbix_agentd -O /opt/bin/zabbix_agentd && \
chmod +x /opt/bin/zabbix_agentd

echo "Starting Config Generation"
CONF="/opt/etc/zabbix/"

if [ -z ${ZABBIX_SERVER} ]; then
    echo "No default zabbix-server provided. Exiting ..."
    exit 1
fi

if [ -z ${REMOTE_COMMAND} ]; then
    echo "No Remote Command Configuration Provided. Assuming 0 (no support)"
    REMOTE_COMMAND=0
fi

if [ -z ${ZABBIX_SERVER_PORT} ];then
    echo "No Zabbix Server Port Provided. Assuming 10051."
    ZABBIX_SERVER_PORT=10051
fi

if [ ! -d "$CONF" ]; then

mkdir -p $CONF/zabbix_agentd.conf.d

cat <<EOT > $CONF/zabbix_agentd.conf
LogFile=/tmp/zabbix_server.log
LogFileSize=1024
LogType=console
ListenPort=10050
DebugLevel=3
EnableRemoteCommands=$REMOTE_COMMAND
LogRemoteCommands=1
Server=$ZABBIX_SERVER
ServerActive=$ZABBIX_SERVER:$ZABBIX_SERVER_PORT
Timeout=30
Include=/opt/etc/zabbix/zabbix_agentd.conf.d
EOT

    touch /tmp/firstrun
fi

