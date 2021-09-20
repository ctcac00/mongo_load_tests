#!/bin/bash

# List of EC2 hosts
declare -a hostList=$( cd terraform/aws && terraform output loadtest-demo_public_dns | sed -r 's/[][,]//g' )

for host in ${hostList[@]}; do

echo "killing locust at ${host}..."

ssh -o StrictHostKeyChecking=accept-new -i keyfile.pem ubuntu@${host} << EOF
pkill locust
EOF

echo "done!"

done
