#!/usr/bin/env bash
# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

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
