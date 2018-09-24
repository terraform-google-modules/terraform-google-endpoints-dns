#!/usr/bin/env bash

fly -t tf set-pipeline -p tf-examples-ep-dns-gce-acme -c tests/pipelines/tf-examples-ep-dns-gce-acme.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-ep-dns-pull-requests -c tests/pipelines/tf-ep-dns-pull-requests.yaml -l tests/pipelines/values.yaml
fly -t tf set-pipeline -p tf-ep-dns-regression -c tests/pipelines/tf-ep-dns-regression.yaml -l tests/pipelines/values.yaml

fly -t tf expose-pipeline -p tf-examples-ep-dns-gce-acme
fly -t tf expose-pipeline -p tf-ep-dns-pull-requests
fly -t tf expose-pipeline -p tf-ep-dns-regression