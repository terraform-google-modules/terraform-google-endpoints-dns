#!/bin/bash -ex
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

# Extract JSON args into shell variables
JQ=$(command -v jq || true)
[[ -z "${JQ}" ]] && echo "ERROR: Missing command: 'jq'" >&2 && exit 1

eval "$(${JQ} -r '@sh "ENDPOINT=\(.endpoint) PROJECT=\(.project)"')"

function log() {
    level=$1
    msg=$2
    echo "${LEVEL}: $msg" >&2
}

TMP_DIR=$(mktemp -d)
function cleanup() {
  rm -rf "${TMP_DIR}"
}
trap cleanup EXIT

if [[ ! -z ${GOOGLE_PROJECT+x} ]]; then
  gcloud config set project "${GOOGLE_PROJECT}"
fi

log "INFO" "Forcing undelete of Endpoint Service"
gcloud endpoints services undelete ${ENDPOINT} --project ${PROJECT} >&2 || true

# Output results in JSON format.
jq -n \
  --arg endpoint "${ENDPOINT}" \
  --arg project "${PROJECT}" \
    '{"endpoint":$endpoint, "project":$project}'
