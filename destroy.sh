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
  echo >&2 "Environment variable GCLOUD_PROJECT_ID is empty, please define it to continue"
  exit 1
fi

set -e

# Build terraform destroy command with optional variables
terraform_vars="-var project_id=${GCLOUD_PROJECT_ID}"

if [[ -n "$REGION" ]]; then
  terraform_vars="$terraform_vars -var region=${REGION}"
fi

if [[ -n "$ZONE" ]]; then
  terraform_vars="$terraform_vars -var zone=${ZONE}"
fi

terraform -chdir=terraform destroy $terraform_vars -auto-approve

rm client.ovpn || true
