# Cloud Endpoints DNS Module for Terraform

<a href="https://concourse-tf.gcp.solutions/teams/main/pipelines/tf-ep-dns-regression" target="_blank">
<img src="https://concourse-tf.gcp.solutions/api/v1/teams/main/pipelines/tf-ep-dns-regression/badge" /></a>

This module creates a Cloud Endpoints service bound to an external IP address which gives you a known DNS record in the form of: `NAME.endpoints.PROJECT.cloud.goog`

## Usage

```ruby
module "cloud-ep-dns" {
  source      = "terraform-google-modules/endpoints-dns/google"
  project     = "${data.google_client_config.current.project}"
  name        = "myservice"
  external_ip = "${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip}"
}