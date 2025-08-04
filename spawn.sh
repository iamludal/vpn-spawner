#!/bin/bash

# Parse command line arguments
REGION=""
ZONE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --region)
      REGION="$2"
      shift 2
      ;;
    --zone)
      ZONE="$2"
      shift 2
      ;;
    -h|--help)
      echo "Usage: $0 [--region REGION] [--zone ZONE]"
      echo "  --region REGION  Specify the GCP region (optional)"
      echo "  --zone ZONE      Specify the GCP zone (optional)"
      echo ""
      echo "Required environment variable:"
      echo "  GCLOUD_PROJECT_ID  Your Google Cloud project ID"
      exit 0
      ;;
    *)
      echo "Unknown option $1"
      echo "Use --help for usage information"
      exit 1
      ;;
  esac
done

if [[ -z "$GCLOUD_PROJECT_ID" ]]; then
  echo >&2 "Environment variable GCLOUD_PROJECT_ID is empty"
  exit 1
fi

set -e

terraform -chdir=terraform init

# Build terraform apply command with optional variables
terraform_vars="-var project_id=${GCLOUD_PROJECT_ID}"

if [[ -n "$REGION" ]]; then
  terraform_vars="$terraform_vars -var region=${REGION}"
fi

if [[ -n "$ZONE" ]]; then
  terraform_vars="$terraform_vars -var zone=${ZONE}"
fi

terraform -chdir=terraform apply -auto-approve $terraform_vars

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
