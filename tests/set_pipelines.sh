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

fly -t tf set-pipeline -p tf-examples-ep-dns-gce-acme -c tests/pipelines/tf-examples-ep-dns-gce-acme.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-ep-dns-pull-requests -c tests/pipelines/tf-ep-dns-pull-requests.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-ep-dns-regression -c tests/pipelines/tf-ep-dns-regression.yaml -l tests/pipelines/values.yaml

fly -t tf expose-pipeline -p tf-examples-ep-dns-gce-acme
fly -t tf expose-pipeline -p tf-ep-dns-pull-requests
fly -t tf expose-pipeline -p tf-ep-dns-regression