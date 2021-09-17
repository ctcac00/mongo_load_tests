#!/bin/bash

# MongoDB URI
MONGO_URI="mongodb+srv//somecluster.abcdef.mongodb.net/sample"

# List of EC2 hosts
declare -a hostList=(   "dns-name-1"
  "dns-name-2"
  "dns-name-3"
  "dns-name-n" )

for host in ${hostList[@]}; do

echo "killing locust at ${host}..."

ssh -o StrictHostKeyChecking=accept-new -i keyfile.pem ubuntu@${host} << EOF
pkill locust
EOF

echo "done!"

done
