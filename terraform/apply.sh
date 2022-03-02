#!/usr/bin/env sh

set -e

terraform apply -var-file=environments/${1}/variables.tfvars