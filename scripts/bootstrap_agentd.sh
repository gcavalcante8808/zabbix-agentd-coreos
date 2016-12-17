#!/bin/bash
set -e

if [ ! -d "/opt/bin" ]; then
    mkdir -p /opt/{bin,etc,lib}
fi

if [ ! -f "/opt/bin/zabbix_agentd" ]; then
    echo "Downloading Zabbix Agentd $ZBX_VERSION"
    wget https://github.com/gcavalcante8808/zabbix-agentd-coreos/releases/download/$ZBX_VERSION/zabbix_agentd.tar -O /tmp/zabbix_agentd.tar && \
    cd /tmp && \
    tar xf zabbix_agentd.tar && \
    mv zabbix_agentd /opt/bin/ && \
    mv libssl.so.10 /opt/lib/ && \
    mv libcrypto.so.10 /opt/lib/ && \
    chmod +x /opt/bin/zabbix_agentd
    rm /tmp/zabbix_agentd.tar
fi

CONF="/opt/etc/zabbix/"

if [ -z $ZABBIX_SERVER ]; then
    echo "No default zabbix-server provided. Exiting ..."
    exit 1
fi

if [ -z $REMOTE_COMMAND ]; then
    echo "No Remote Command Configuration Provided. Assuming 0 (no support)"
    REMOTE_COMMAND=0
fi

if [ -z $ZABBIX_SERVER_PORT ];then
    echo "No Zabbix Server Port Provided. Assuming 10051."
    ZABBIX_SERVER_PORT=10051
fi

if [ ! -d "$CONF" ]; then

echo "Starting Config Generation"
mkdir -p $CONF/zabbix_agentd.conf.d
mkdir -p /run/zabbix
chown -R zabbix /run/zabbix

cat <<EOT > $CONF/zabbix_agentd.conf
LogFile=/tmp/zabbix_agentd.log
PidFile=/tmp/zabbix_agentd.pid
LogFileSize=1024
ListenPort=10050
DebugLevel=3
EnableRemoteCommands=$REMOTE_COMMAND
LogRemoteCommands=1
Server=$ZABBIX_SERVER
ServerActive=$ZABBIX_SERVER:$ZABBIX_SERVER_PORT
Timeout=30
Include=/opt/etc/zabbix/zabbix_agentd.conf.d
EOT
fi

