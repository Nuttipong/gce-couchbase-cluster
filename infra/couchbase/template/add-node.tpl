#!/bin/bash
curl -O https://packages.couchbase.com/releases/couchbase-release/couchbase-release-1.0-amd64.deb
sudo dpkg -i ./couchbase-release-1.0-amd64.deb
sudo apt-get update
sudo apt-get install couchbase-server
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

check_host() {
  curl --silent http://${public_ip}:8091/pools > /dev/null
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
  >&2 log "Waiting for Couchbase Server to be available ..." > /dev/checkdb_logs.txt
  sleep 1
done

# Wait until host ready
until [[ $(check_host) = 0 ]]; do
  >&2 log "Waiting for Couchbase Server host to be available ..." > /dev/checkhost_logs.txt
  sleep 1
done


IP=$(hostname -I)
echo $IP

add_server() {
./couchbase-cli server-add -c ${public_ip}:8091 \
--username Administrator \
--password password \
--server-add $IP \
--server-add-username admin \
--server-add-password password \
--services data,index,query > /dev/null
  echo $?
}

until [[ $(add_server) = 0 ]]; do
  >&2 log "Waiting for add new server to be available ..." > /dev/addserver_logs.txt
  sleep 1
done

./couchbase-cli rebalance -c ${public_ip}:8091 \
--username Administrator \
--password password

sleep 30