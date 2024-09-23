#!/bin/bash

if [[ -z "$GCLOUD_PROJECT_ID" ]]; then
  echo >&2 "Environment variable GCLOUD_PROJECT_ID is empty, please define it to continue"
  exit 1
fi

set -e

terraform -chdir=terraform destroy -var project_id=${GCLOUD_PROJECT_ID} -auto-approve

rm client.ovpn || true
