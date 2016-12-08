#!/bin/bash
set -e

echo "Downloading Zabbix Agentd ${ZBX_VERSION}"
wget https://github.com/gcavalcante8808/zabbix-agentd-coreos/releases/download/{$ZBX_VERSION}/zabbix_agentd -O /opt/bin/zabbix_agentd && \
chmod +x /opt/bin/zabbix_agentd

echo "Download Configuration BootStrap Script"
wget https://raw.githubusercontent.com/gcavalcante8808/docker-zabbix-agent/master/files/docker-entrypoint.sh -O /tmp/bootstrap.sh && \
chmod +x /tmp/bootstrap.sh

