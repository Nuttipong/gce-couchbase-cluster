## Couchbase 

## Dockerhub
Download [click](https://hub.docker.com/_/couchbase?tab=tags)
translate ship code intel(new) -> applet m1 code(old binary)
```
softwareupdate --install-rosetta
```
Ref: https://www.beartai.com/news/itnews/501956

## Accessing the CLI Tools
Ref: https://docs.couchbase.com/server/current/install/macos-install.html

## Access documents in Couchbase using command N1QL
```
brew install libcouchbase
```
Ref: https://docs.couchbase.com/go-sdk/1.6/webui-cli-access.html

## Cluster configuration
| Community   | Enterprise | 
| ----------- | ----------- |
| Cluster can only share the same configuration Data, Index, and Query for each futer node | Cluster can share the heterogenous configuration Data, Index, Query, and Size for futer node |

## Index storing have 2 modes
- Standard global secondary index -> indexes are stored on disk, and memory use for update and scanning
- Memory-optimized -> indexes are stored on memory, and memory use for update and scanning(only Enterprise)

## Scaling out or herizontal scaling
1. Add node with configuration
2. Rebalancing

## How to setup Couchbase server
```
wget https://packages.couchbase.com/release/6.5.0/couchbase-server-enterprise_6.5.0-ubuntu18.04_amd64.deb
sudo dpkg -i couchbase-server-enterprise_6.5.0-ubuntu18.04_amd64.deb
```
Ref: https://docs.couchbase.com/server/current/install/ubuntu-debian-install.html


## How to create cluster
```
./couchbase-cli cluster-init -c 127.0.0.1 \
--cluster-username Administrator \
--cluster-password password \
--services data,index,query \
--cluster-ramsize 512 \
--cluster-index-ramsize 256

# access cluster > http:127.0.0.1:8091
```

## How to create bucket
```
couchbase-cli bucket-create \
--cluster 127.0.0.1:8091 \
--username Administrator \
--password password \
--bucket myBucket \
--bucket-type couchbase \
--bucket-ramsize 100 \
--bucket-replica 0 \
--durability-min-level persistToMajority \
--enable-flush 0
```
Ref: https://docs.couchbase.com/server/current/manage/manage-buckets/create-bucket.html

## Bucket type

| Bucket      | Description | 
| ----------- | ----------- |
| Couchbase   | Memory first, Data will be stored and retrieved memory first. if document is not found. it will then load from the disk into the cache, if the cache is full, not recently used documents are ejected from the cache but remain on the disk|
| Memcached   | Memory only, Data will be stored and retrieved memory only. if the cache is full and item is  added older items will be completely ejected and treats to exist. No replication, No compression, backup, query available|
| Ephemeral   | Memory only, Data will be stored and retrieved memory only. No disk access is used, if cache is full and item is added older item will be ejected or addition will fail depending on how you configure it|

## Buckets, Shards, and vBuckets
Couchbase bucket has a fixed amount 1,024 shards this also called ==vBuckets==

## Put data into a bucket
```
```

## Data sharding
Couchbase automatically sharding for us

## Rebalancing calculate item store each node
Whenever node enter or leave a cluster, data and indexes are redistributed across available nodes. this process is known as rebalancing
ex) if we have 31,594 documents, 3 nodes, and 2 replicas in the cluster

- How many docs each node = 31,594 / 3 = ~10531
- How many replica docs each node = 31,594 * (2) / 3 = ~21062


## Handling failure when node fail
1. Remove and Rebalancing = this is good for plan updates and maintainance
we just falg server removal and manual rebalancing
2. Failover = for unplaned outaged of individual nodes
- Manual vs Automatic
- Graceful vs Hard

## How to adding a new node
1. ssh to a new server and install couchbase as before
2. switch over to previous server and 
```
cd /opt/couchbase/bin
couchbase-cli server-add -c {existing cluster ip:port} \
--username Administrator \
--password password \
--server-add {ip} \
--server-add-username {name} \ 
--server-add-password {pwd} \ 
--services data index

./couchbase-cli server-add -c 34.126.118.183:8091 \
--username Administrator \
--password password \
--server-add 10.148.15.208 \
--server-add-username admin \
--server-add-password password \
--services data,index,query

./couchbase-cli rebalance -c 34.126.118.183:8091 \
--username Administrator \
--password password


couchbase-cli rebalance -c {existing cluster ip:port} \
--username Administrator \
--password password
```

## Viewing cluster info
Individual node
```
curl -u Administrator:password http:/{cluster-ip:port}/pools
```
All nodes
```
curl -u Administrator:password http:/{cluster-ip:port}/pools/default
```

## Graceful Failover
- proactive remove service data
- no downtime or loss of client access to data
- must be manually typically done by taken out for MA
- only applicable ==data== service

## Hard Failover
- drop a node from a cluster after it has become unavailable
- applicable for all services

## Couchbase Indexes
1. Primary indexes
- search will perform only document key, no filters, and no predecates
- maintain by indexes service
2. Secondary indexes(GSI)
- based on attributes value within the document contains one or more attributes of documents
- any queries involve those attributes can be perform using indexes itself and lookup in memory not go through the disk 
- maintain by indexes service
3. Full-text search
- target textual content of document
- document can be in one or more buckets
- maintain by search service
4. View
- fields and information extracted from document

## Create Indexes
```
create index `name` on `bucket`(`attribute`);
select * from system:indexes where name=`name`;

create index `name` on `bucket`(`attribute`) using gsi;

create index `name` on `bucket`(`att1, attr2`) where field=value;
```

## N1QL basic


## Terraform CLI
```
> terraform init
> terraform validate
> terraform workspace list
> terraform workspace new prod
> terraform workspace select prod
> terraform plan -out state.tfplan
> terraform plan -out state.tfplan -var-file="terraform.tfvars"
> terraform apply "state.tfplan"
> terraform destroy
> terraform destroy -auto-approve
```

## Log
```
cat /var/log/syslog
```

## M1 isuue
https://discuss.hashicorp.com/t/template-v2-2-0-does-not-have-a-package-available-mac-m1/35099/7

## How to access Couchbase and perform N1QL
https://www.thepolyglotdeveloper.com/2016/08/using-couchbase-server-golang-web-application/

## How to wait until Couchbase server ready
https://forums.couchbase.com/t/how-to-create-preconfigured-couchbase-docker-image-with-data/17004
```
#!/bin/bash

# Enables job control
set -m

# Enables error propagation
set -e

# Run the server and send it to the background
/entrypoint.sh couchbase-server &

# Check if couchbase server is up
check_db() {
  curl --silent http://127.0.0.1:8091/pools > /dev/null
  echo $?
}

# Variable used in echo
i=1
# Echo with
log() {
  echo "[$i] [$(date +"%T")] $@"
  i=`expr $i + 1`
}

# Wait until it's ready
until [[ $(check_db) = 0 ]]; do
  >&2 log "Waiting for Couchbase Server to be available ..."
  sleep 1
done

# Setup index and memory quota
log "$(date +"%T") Init cluster ........."
couchbase-cli cluster-init -c 127.0.0.1 --cluster-username Administrator --cluster-password password \
  --cluster-name myCluster --cluster-ramsize 1024 --cluster-index-ramsize 512 --services data,index,query,fts \
  --index-storage-setting default

# Create the buckets
log "$(date +"%T") Create buckets ........."
couchbase-cli bucket-create -c 127.0.0.1 --username Administrator --password password --bucket-type couchbase --bucket-ramsize 250 --bucket bucket1
couchbase-cli bucket-create -c 127.0.0.1 --username Administrator --password password --bucket-type couchbase --bucket-ramsize 250 --bucket bucket2

# Create user
log "$(date +"%T") Create users ........."
couchbase-cli user-manage -c 127.0.0.1:8091 -u Administrator -p password --set --rbac-username sysadmin --rbac-password password \
 --rbac-name "sysadmin" --roles admin --auth-domain local

couchbase-cli user-manage -c 127.0.0.1:8091 -u Administrator -p password --set --rbac-username admin --rbac-password password \
 --rbac-name "admin" --roles bucket_full_access[*] --auth-domain local

# Need to wait until query service is ready to process N1QL queries
log "$(date +"%T") Waiting ........."
sleep 20

# Create bucket1 indexes
echo "$(date +"%T") Create bucket1 indexes ........."
cbq -u Administrator -p password -s "CREATE PRIMARY INDEX idx_primary ON \`bucket1\`;"
cbq -u Administrator -p password -s "CREATE INDEX idx_type ON \`bucket1\`(_type);"
cbq -u Administrator -p password -s "CREATE INDEX idx_account_id ON \`bucket1\`(id) WHERE (_type = \"account\");"

# Create bucket2 indexes
echo "$(date +"%T") Create bucket2 indexes ........."
cbq -u Administrator -p password -s "CREATE PRIMARY INDEX idx_primary ON \`bucket1\`;"
cbq -u Administrator -p password -s "CREATE INDEX idx_event_ruleId ON \`bucket1\`(ruleId) WHERE (_type = \"event\");"
cbq -u Administrator -p password -s "CREATE INDEX idx_event_startTime ON \`bucket1\`(startTime) WHERE (_type = \"event\");"

fg 1
```

