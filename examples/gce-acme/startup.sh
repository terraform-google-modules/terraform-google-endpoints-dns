#!/bin/bash -xe
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

apt-get update -y
apt-get install -y nginx
apt-get install -y python-certbot-nginx -t stretch-backports

function acme() {
    ACME_EMAIL=$(curl -sf -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/ACME_EMAIL)
    ENDPOINT=$(curl -sf -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/ENDPOINT)
    ACME_SERVER=$(curl -sf -H "Metadata-Flavor: Google" http://metadata/computeMetadata/v1/instance/attributes/ACME_SERVER)

    # Wait for DNS to propagate for new records.
    (until [[ -n "$(getent hosts ${ENDPOINT} || true)" ]]; do echo "Waiting for DNS: ${ENDPOINT}"; sleep 5; done)

    # Wait for nginx.
    (until [[ "$(curl -m 5 -s -o /dev/null -w '%{http_code}' -L http://${ENDPOINT})" -eq 200 ]]; do echo "Waiting for Nginx: http://${ENDPOINT}"; sleep 5; done)

    # Configure nginx
    sed -i "s/server_name _/server_name ${ENDPOINT}/g" /etc/nginx/sites-available/default
    nginx -t
    systemctl reload nginx

    # Run certbot
    certbot -n --nginx --redirect --agree-tos --no-eff-email --email ${ACME_EMAIL} --server ${ACME_SERVER} -d ${ENDPOINT}    
}

# Run acme config
acme