#!/bin/bash

# exit when any command fails
set -e

# MongoDB URI
MONGO_URI=$(cd terraform/atlas && terraform output connection_string)

# List of EC2 hosts
declare -a hostList=$(cd terraform/aws && terraform output loadtest-demo_public_dns | sed -r 's/[][,]//g' )

counter=1
# Start locust
for host in ${hostList[@]}; do
host=$(echo ${host} | tr -d '"')

echo "starting POCDriver..."

ssh -o StrictHostKeyChecking=accept-new -i keyfile.pem ubuntu@${host} << EOF
sudo apt install -y default-jre
git clone https://github.com/carlosmdb/POCDriver.git
cd POCDriver/bin
java -jar POCDriver.jar -c "${MONGO_URI}" -k 20 -i 10 -u 10 -b 20 -t 256
EOF

echo "done!"

counter=$((counter +1))

done
