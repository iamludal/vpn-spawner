#!/bin/bash

gcloud_project_id=TODO

set -e

terraform -chdir=terraform destroy -var project_id=${gcloud_project_id} -auto-approve

rm ~/client.ovpn || true
