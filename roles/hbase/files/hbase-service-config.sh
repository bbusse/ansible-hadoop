#!/usr/bin/env bash

set -xueo pipefail

HBASE_SYSTEMD_UNIT_TEMPLATE="/tmp/hadoop/etc/hadoop/hdfs-bootstrap.service.j2"
HBASE_SYSTEMD_ENV_TEMPLATE="/etc/systemd-env-hbase.j2"

source setup.sh

create_hbase_systemd_env_template() {
    read -r -d '' CONFIG <<EOF
JAVA_HOME={{ java_home }}
HADOOP_HOME={{ hadoop_home }}
EOF
    echo "$CONFIG"
}

create_hbase_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HBase Master
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile={{ service_env_file }}
Type=Forking
ExecStart={{ hbase_cmd }}
WorkingDirectory={{ hbase_working_dir }}
TimeoutStartSec=2min
PIDFile={{ hbase_pid_file }}

[Install]
WantedBy=multi-user.target
EOF
    echo "$CONFIG"
}

HBASE_TEMPLATE=$(create_hbase_systemd_unit_template)
HBASE_ENV_TEMPLATE=$(create_hbase_systemd_env_template)
write_file ${HBASE_SYSTEMD_UNIT_TEMPLATE} "${HBASE_TEMPLATE}"
write_file ${HBASE_SYSTEMD_ENV_TEMPLATE} "${HBASE_ENV_TEMPLATE}"
