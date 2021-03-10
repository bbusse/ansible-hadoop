#!/usr/bin/env bash

set -xueo pipefail

HDFS_BOOTSTRAP_SYSTEMD_UNIT_TEMPLATE="/tmp/hadoop/etc/hadoop/hdfs-bootstrap.service.j2"
HDFS_NAMENODE_SYSTEMD_UNIT_TEMPLATE="/tmp/hadoop/etc/hadoop/hdfs-namenode.service.j2"
HDFS_DATANODE_SYSTEMD_UNIT_TEMPLATE="/tmp/hadoop/etc/hadoop/hdfs-datanode.service.j2"
HDFS_JOURNALNODE_SYSTEMD_UNIT_TEMPLATE="/tmp/hadoop/etc/hadoop/hdfs-journalnode.service.j2"
HDFS_SYSTEMD_ENV_TEMPLATE="/tmp/hadoop/etc/hadoop/systemd-env-hdfs.j2"

source setup.sh

create_hdfs_systemd_env_template() {
    read -r -d '' CONFIG <<EOF
JAVA_HOME=/tmp/hadoop
HADOOP_HOME=/tmp/hadoop
EOF
    echo $CONFIG
}

create_hdfs_bootstrap_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HDFS namenode
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile=/etc/systemd-env-hdfs
Type=oneshot
ExecStartPre={{ hdfs_cmd_format }}
ExecStart={{ hdfs_cmd_format_ha }}
WorkingDirectory=/tmp/hadoop/
TimeoutStartSec=2min
PIDFile=/tmp/hadoop-hadoop-namenode.pid

[Install]
WantedBy=multi-user.target
EOF
    echo "$CONFIG"
}
create_hdfs_namenode_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HDFS namenode
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile=/etc/systemd-env-hdfs
Type=forking
ExecStart=
ExecStop=
WorkingDirectory=/tmp/hadoop/
TimeoutStartSec=2min
Restart=on-failure
PIDFile=/tmp/hadoop-hadoop-namenode.pid

[Install]
WantedBy=multi-user.target
EOF
    echo $CONFIG
}

create_hdfs_datanode_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HDFS namenode
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile=/etc/systemd-env-hdfs
Type=forking
ExecStart={{ hdfs_cmd_namenode_start }}
WorkingDirectory=/tmp/hadoop/
TimeoutStartSec=2min
Restart=on-failure
PIDFile=/tmp/hadoop-hadoop-namenode.pid

[Install]
WantedBy=multi-user.target
EOF
    echo $CONFIG
}

create_hdfs_datanode_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HDFS namenode
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile=/etc/systemd-env-hdfs
Type=forking
ExecStart={{ hdfs_cmd_datanode_start }}
WorkingDirectory=/tmp/hadoop/
TimeoutStartSec=2min
Restart=on-failure
PIDFile=/tmp/hadoop-hadoop-namenode.pid

[Install]
WantedBy=multi-user.target
EOF
    echo $CONFIG
}

create_hdfs_journalnode_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HDFS namenode
After=network-online.target
Requires=network-online.target

[Service]
User=hdfs
Group=hdfs
EnvironmentFile=/etc/systemd-env-hdfs
Type=forking
ExecStart={{ hdfs_cmd_journalnode_start }}
WorkingDirectory=/tmp/hadoop/
TimeoutStartSec=2min
Restart=on-failure
PIDFile=/tmp/hadoop-hadoop-namenode.pid

[Install]
WantedBy=multi-user.target
EOF
    echo $CONFIG
}

HDFS_BOOTSTRAP_TEMPLATE=$(create_hdfs_bootstrap_systemd_unit_template)
HDFS_NAMENODE_TEMPLATE=$(create_hdfs_namenode_systemd_unit_template)
HDFS_DATANODE_TEMPLATE=$(create_hdfs_datanode_systemd_unit_template)
HDFS_JOURNALNODE_TEMPLATE=$(create_hdfs_journalnode_systemd_unit_template)
HDFS_ENV_TEMPLATE=$(create_hdfs_systemd_env_template)
write_file ${HDFS_BOOTSTRAP_SYSTEMD_UNIT_TEMPLATE} "${HDFS_BOOTSTRAP_TEMPLATE}"
write_file ${HDFS_NAMENODE_SYSTEMD_UNIT_TEMPLATE} "${HDFS_NAMENODE_TEMPLATE}"
write_file ${HDFS_DATANODE_SYSTEMD_UNIT_TEMPLATE} "${HDFS_DATANODE_TEMPLATE}"
write_file ${HDFS_JOURNALNODE_SYSTEMD_UNIT_TEMPLATE} "${HDFS_JOURNALNODE_TEMPLATE}"
write_file ${HDFS_SYSTEMD_ENV_TEMPLATE} "${HDFS_ENV_TEMPLATE}"
