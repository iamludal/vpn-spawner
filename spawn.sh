#!/bin/bash

if [[ -z "$GCLOUD_PROJECT_ID" ]]; then
  echo >&2 "Environment variable GCLOUD_PROJECT_ID is empty"
  exit 1
fi

set -e

terraform -chdir=terraform init

terraform -chdir=terraform apply -auto-approve -var project_id=${GCLOUD_PROJECT_ID}

outputs=$(terraform -chdir=terraform output -json)
ip_address=$(echo "$outputs" | jq -r '.ip_address.value')
ssh_key_path=$(echo "$outputs" | jq -r '.ssh_key_path.value')

# wait for sshd to start
while ! ssh -i ${ssh_key_path} -o ConnectTimeout=1 -o StrictHostKeyChecking=no user@${ip_address} exit; do
    echo "Waiting for sshd to start..."
    sleep 1
done

export ANSIBLE_HOST_KEY_CHECKING=False

ansible-playbook ansible/playbook.yaml -i user@${ip_address}, --private-key ${ssh_key_path}

echo "Your VPN server is ready! You can now connect to it using the client.ovpn config file"
