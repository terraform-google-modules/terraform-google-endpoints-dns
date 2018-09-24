#!/bin/bash -ex

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

if [[ ! -z ${GOOGLE_CREDENTIALS+x} && ! -z ${GOOGLE_PROJECT+x} ]]; then
  export CLOUDSDK_CONFIG=${TMP_DIR}
  gcloud auth activate-service-account --key-file - <<<"${GOOGLE_CREDENTIALS}"
  gcloud config set project "${GOOGLE_PROJECT}"
fi

log "INFO" "Enabling Service Management API"
gcloud services enable servicemanagement.googleapis.com serviceusage.googleapis.com --project ${PROJECT} >&2

log "INFO" "Forcing undelete of Endpoint Service"
gcloud endpoints services undelete ${ENDPOINT} --project ${PROJECT} >&2 || true

# Output results in JSON format.
jq -n \
  --arg endpoint "${ENDPOINT}" \
  --arg project "${PROJECT}" \
    '{"endpoint":$endpoint, "project":$project}'