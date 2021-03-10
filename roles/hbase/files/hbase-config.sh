#!/usr/bin/env bash

set -ueo pipefail

HBASE_PATH="/tmp"
HBASE_CONFIG_TEMPLATE="${HBASE_PATH}/hbase/conf/hbase-site.xml.j2"

SCRIPT_PATH=$(dirname "$0")
source $SCRIPT_PATH/../../../setup.sh

create_hbase_config_template() {
    read -r -d '' CONFIG <<EOF
<?xml version="1.0"?>
<?xml-stylesheet type="text/xsl" href="configuration.xsl"?>
<configuration>
  <property>
    <name>hbase.rootdir</name>
    <value>file:///{{ hbase_rootdir }}/hbase</value>
  </property>
  <property>
    <name>hbase.zookeeper.property.dataDir</name>
    <value>{{ hbase_datadir }}/zookeeper</value>
  </property>
  <property>
    <name>hbase.unsafe.stream.capability.enforce</name>
    <value>false</value>
  </property>
</configuration>
EOF
    echo "$CONFIG"
}

HBASE_CONFIG=$(create_hbase_config_template)
write_file ${HBASE_CONFIG_TEMPLATE} "${HBASE_CONFIG}"
