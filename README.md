# ansible-hadoop

## About
Bootstraps a HDFS/Hbase cluster with Ansible

## Usage
```
$ ansible-playbook -i inventory.yml -e java_home="/" -e hadoop_path="/tmp" -e hdfs_cluster_id="test-cluster" hdfs-create.yml
$ ansible-playbook -i inventory.yml -e java_home="/" -e hbase_path="/tmp" hbase-create.yml
```
