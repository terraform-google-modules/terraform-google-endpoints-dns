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

provider "google" {
  region = var.region
}

data "google_client_config" "current" {
}

resource "google_compute_network" "default" {
  name                    = var.name
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "default" {
  name                     = var.name
  ip_cidr_range            = "10.127.0.0/20"
  network                  = google_compute_network.default.self_link
  region                   = var.region
  private_ip_google_access = true
}

// Cloud Endpoint DNS record created with the IP of the instance.
module "cloud-ep-dns" {
  source      = "../../"
  project     = data.google_client_config.current.project
  name        = var.name
  external_ip = google_compute_instance.default.network_interface[0].access_config[0].assigned_nat_ip
}

data "google_compute_default_service_account" "default" {
}

resource "google_compute_instance" "default" {
  name         = var.name
  machine_type = "g1-small"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
      size  = "10"
    }
  }

  network_interface {
    access_config {
    }
    subnetwork = google_compute_subnetwork.default.name
  }

  metadata = {
    ACME_EMAIL  = var.acme_email
    ACME_SERVER = var.acme_server
    // note that the output variable referenced here is not dependent on the endpoint creation.
    // This is done so that we can use the ephemeral nat_ip of the instance in the cloud endpoint without creating a dependency cycle.
    // The instance startup script has a step to wait for the DNS to propagate before attempting the acme challenge.
    ENDPOINT = module.cloud-ep-dns.endpoint
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = [var.name]

  service_account {
    email  = data.google_compute_default_service_account.default.email
    scopes = ["userinfo-email", "compute-ro"]
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "${var.name}-ssh"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  target_service_accounts = [data.google_compute_default_service_account.default.email]
  source_ranges           = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "default" {
  name    = "${var.name}-web"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  target_service_accounts = [data.google_compute_default_service_account.default.email]
}

output "ssh" {
  value = "gcloud compute ssh ${google_compute_instance.default.name} --zone ${var.zone}"
}

output "external_ip" {
  value = module.cloud-ep-dns.external_ip
}

output "endpoint" {
  value = module.cloud-ep-dns.endpoint
}
