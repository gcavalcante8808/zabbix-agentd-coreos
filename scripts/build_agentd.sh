#!/bin/bash
set -ev
cd /usr/local/src && \
   wget http://ufpr.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/${ZBX_VERSION}/zabbix-${ZBX_VERSION}.tar.gz && \
   tar xf zabbix-${ZBX_VERSION}.tar.gz && \
   cd /usr/src/zabbix-${ZBX_VERSION} && \
   ./configure --enable-agent --enable-static && \
   make -j && make install
