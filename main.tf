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

locals {
  project      = var.project
  external_ip  = var.external_ip
  service_name = "${local.name}.endpoints.${local.project}.cloud.goog"
  name         = var.name
}

data "template_file" "openapi_spec" {
  template = file("${path.module}/scripts/openapi_spec.yaml")

  vars = {
    endpoint_service = local.service_name
    target           = local.external_ip
  }
}

// Ensure the service management API is enabled.
resource "google_project_service" "endpoints" {
  project            = local.project
  service            = "servicemanagement.googleapis.com"
  disable_on_destroy = false
}

// Ensure the service usage API is enabled.
resource "google_project_service" "service-usage" {
  project            = local.project
  service            = "serviceusage.googleapis.com"
  disable_on_destroy = false
}

// Ensure that the service endpoint has not been deleted by trying to undelete it with gcloud.
data "external" "module-cloudep-dns-prep" {
  count   = var.ensure_undelete ? 1 : 0
  program = ["${path.module}/scripts/cloudep_prep.sh"]

  query = {
    endpoint = local.service_name
    project  = local.project
  }
}

resource "google_endpoints_service" "default" {
  service_name   = local.service_name
  project        = local.project
  openapi_config = data.template_file.openapi_spec.rendered

  depends_on = [
    google_project_service.endpoints,
    google_project_service.service-usage,
  ]
}

