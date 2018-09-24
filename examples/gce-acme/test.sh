#!/usr/bin/env bash

set -x
set -e

ENDPOINT=$(terraform output endpoint)

echo "INFO: Verifying HTTPS endpoint: ${EXTERNAL_IPS[*]}"

count=0
http_code=0
while [[ $count -lt 1200 && "${http_code}" -ne 200 ]]; do
  http_code=$(curl -m 5 -s -o /dev/null -w "%{http_code}" -k https://${ENDPOINT} || true)
  ((count=count+1))
  sleep 5
done
test $count -lt 1200

echo "PASS: HTTPS service found at: ${ENDPOINT}"
