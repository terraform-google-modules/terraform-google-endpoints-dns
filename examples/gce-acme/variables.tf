/**
 * Copyright 2018 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "acme_email" {
    description = "Email to send ACME renewal notifications to."
}

variable "acme_server" {
  description = "ACME API server, set to https://acme-staging-v02.api.letsencrypt.org/directory to use the staging API."
  default     = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "region" {
  description = "Region to configure the provider and create resources in."
  default = "us-central1"
}

variable "zone" {
  description = "Zone to create resources like the subnetwork and compute_instance."
  default = "us-central1-c"
}

variable "name" {
  description = "Name used for the endpoint and when creating resources like the network and compute_instance."
  default = "tf-ep-dns"
}