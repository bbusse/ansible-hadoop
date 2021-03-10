#!/usr/bin/env bash

set -ueo pipefail

HBASE_MASTER_SYSTEMD_UNIT_TEMPLATE="/tmp/hbase/conf/hbase-master.service.j2"
HBASE_REGIONSERVER_SYSTEMD_UNIT_TEMPLATE="/tmp/hbase/conf/hbase-regionserver.service.j2"
HBASE_SYSTEMD_ENV_TEMPLATE="/tmp/hbase/conf/systemd-env-hbase.j2"

source setup.sh

create_hbase_systemd_env_template() {
    read -r -d '' CONFIG <<EOF
JAVA_HOME={{ java_home }}
EOF
    echo "$CONFIG"
}

create_hbase_master_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HBase Master
After=network-online.target
Requires=network-online.target

[Service]
User={{ service_user }}
Group={{ service_user }}
EnvironmentFile={{ service_env_file }}
Type=Forking
ExecStart={{ hbase_cmd_master }}
WorkingDirectory={{ service_working_dir }}
TimeoutStartSec=2min
PIDFile={{ hbase_master_pid_file }}
Restart=on-failure
Restartsec={{ service_failure_restart_interval_s }}

[Install]
WantedBy=multi-user.target
EOF
    echo "$CONFIG"
}

create_hbase_regionserver_systemd_unit_template() {
    read -r -d '' CONFIG <<EOF
[Unit]
Description=HBase Master
After=network-online.target
Requires=network-online.target

[Service]
User={{ service_user }}
Group={{ service_user }}
EnvironmentFile={{ service_env_file }}
Type=Forking
ExecStart={{ hbase_cmdregionserver }}
WorkingDirectory={{ service_working_dir }}
TimeoutStartSec=2min
PIDFile={{ hbase_regionserver_pid_file }}
Restart=on-failure
Restartsec={{ service_failure_restart_interval_s }}

[Install]
WantedBy=multi-user.target
EOF
    echo "$CONFIG"
}
HBASE_MASTER_TEMPLATE=$(create_hbase_master_systemd_unit_template)
HBASE_REGIONSERVER_TEMPLATE=$(create_hbase_regionserver_systemd_unit_template)
HBASE_ENV_TEMPLATE=$(create_hbase_systemd_env_template)
write_file ${HBASE_MASTER_SYSTEMD_UNIT_TEMPLATE} "${HBASE_MASTER_TEMPLATE}"
write_file ${HBASE_REGIONSERVER_SYSTEMD_UNIT_TEMPLATE} "${HBASE_REGIONSERVER_TEMPLATE}"
write_file ${HBASE_SYSTEMD_ENV_TEMPLATE} "${HBASE_ENV_TEMPLATE}"
