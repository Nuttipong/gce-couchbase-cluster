#!/bin/bash
curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-amd64.deb
sudo dpkg -i ./couchbase-release-1.0-amd64.deb
sudo apt-get update
sudo apt-get install couchbase-server
# sudo apt list -a couchbase-server-community
# sudo apt-get install couchbase-server-community=6.0.0-1693-1
cd /opt/couchbase/bin

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


./couchbase-cli cluster-init -c 127.0.0.1 \
--cluster-username Administrator \
--cluster-password password \
--services data,index,query \
--cluster-ramsize 512 \
--cluster-index-ramsize 256

./couchbase-cli bucket-create \
--cluster 127.0.0.1:8091 \
--username Administrator \
--password password \
--bucket my-bucket \
--bucket-type couchbase \
--bucket-ramsize 100 \
--bucket-replica 1 \
--durability-min-level persistToMajority \
--enable-flush 0


