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

output "project" {
  description = "The project where the cloud endpoint was created."
  value       = local.project
}

output "external_ip" {
  description = "The value of the external IP the endpoint points to."
  value       = local.external_ip
}

output "endpoint" {
  description = "The name of the DNS record conventional to the Cloud Endpoints format of: NAME.endpoints.PROJECT.cloud.goog. Not dependent on google_endpoints_service resource."
  value       = local.service_name
}

output "endpoint_computed" {
  description = "The address of the cloud endpoint. This is computed from the google_endpoints_service resource and can be used to create dependencies between resources."
  value       = google_endpoints_service.default.service_name
}

output "config_id" {
  description = "The rollout config ID for the endpoint service."
  value       = google_endpoints_service.default.config_id
}

output "name" {
  description = "Name of the cloud endpoints service."
  value       = local.name
}
