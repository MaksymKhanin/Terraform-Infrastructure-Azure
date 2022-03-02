#!/usr/bin/env sh

set -e

terraform validate

set +e
terraform plan -var-file=environments/${1}/variables.tfvars \
    -detailed-exitcode

terraform_exitcode=$?
echo "Terraform plan exited with status code ${terraform_exitcode}"

if [ ${terraform_exitcode} -eq 0 ]; then
    echo "No changes detected"
    echo "##vso[task.setvariable variable=terraform_has_changes;isOutput=true;]False"
else
    if [ ${terraform_exitcode} -eq 2 ]; then
    echo "Terraform succeeded with updates"
    echo "##vso[task.setvariable variable=terraform_has_changes;isOutput=true;]True"
    exit 0
    else
    echo "ERROR: terraform exited with code ${terraform_exitcode}"
    exit 1
    fi
fi