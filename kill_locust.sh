#!/bin/bash

# exit when any command fails
#set -e

# List of EC2 hosts
declare -a hostList=$( cd terraform/aws && terraform output loadtest-demo_public_dns | sed -r 's/[][,]//g' )

for host in ${hostList[@]}; do

host=$(echo ${host} | tr -d '"')
echo "killing locust at ${host}..."

ssh -q -o StrictHostKeyChecking=accept-new -i keyfile.pem ubuntu@${host} << EOF
pkill locust
EOF

echo "done!"

done
