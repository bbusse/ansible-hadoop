# ansible-hadoop

## About
Bootstraps a HDFS/Hbase cluster with Ansible

## Usage
```
$ ansible-playbook -i inventory.yml -e java_home="/" -e hadoop_path="/tmp" -e hdfs_cluster_id="test-cluster" hdfs-create.yml
$ ansible-playbook -i inventory.yml -e java_home="/" -e hbase_path="/tmp" hbase-create.yml


## Issues
(No IPv6 support in Hadoop)[https://issues.apache.org/jira/browse/HADOOP-11890]
