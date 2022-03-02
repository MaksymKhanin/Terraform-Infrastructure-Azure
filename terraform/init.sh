#!/usr/bin/env sh

terraform init -reconfigure -upgrade -backend-config=environments/${1}/backend.config