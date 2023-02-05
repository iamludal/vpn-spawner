#!/bin/bash

gcloud_project_id=TODO

terraform -chdir=terraform init

terraform -chdir=terraform apply -auto-approve -var project_id=${gcloud_project_id}

outputs=$(terraform -chdir=terraform output -json)
ip_address=$(echo $outputs | jq -r '.ip_address.value')
ssh_key_path=$(echo $outputs | jq -r '.ssh_key_path.value')

export ANSIBLE_HOST_KEY_CHECKING=False

# wait for sshd to start
while ! ssh -i ${ssh_key_path} -o ConnectTimeout=1 -o StrictHostKeyChecking=no user@${ip_address} exit; do
    echo "Waiting for sshd to start..."
    sleep 1
done

ansible-playbook ansible/playbook.yaml -i user@${ip_address}, --private-key ${ssh_key_path}

echo "Done! Configuration file: ~/client.ovpn"
