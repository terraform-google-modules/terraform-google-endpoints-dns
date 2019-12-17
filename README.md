# Cloud Endpoints DNS Module for Terraform

This module creates a [DNS record on the `.cloud.goog` domain](https://cloud.google.com/endpoints/docs/openapi/openapi-dns-configure) using Cloud Endpoints.

The endpoint service is bound to any given IP address and gives you a known DNS record in the form of: `NAME.endpoints.PROJECT.cloud.goog`

Some example use cases include:
- Obtaining a free DNS record for use with examples, demos or prototypes.
- Obtaining a free DNS record to use in conjunction with a SSL certificate.
- Obtaining a free DNS record to use with the Google Cloud Load Balancer to enable features like IAP which require a known DNS, and valid SSL certificate.
- Obtaining multiple canonical DNS records scoped within a project for a multi-tennant service deployment, like hosting Jupyter notebooks or Wordpress sites.
- Creating a programatic DNS record that can be used as a target for a CNAME record of a domain you already own but don't want to update very often.

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-12.html) and need
a Terraform 0.11.x-compatible version of this module, the last released
version intended for Terraform 0.11.x is [1.1.0](https://registry.terraform.io/modules/terraform-google-modules/endpoints-dns/google/1.1.0).

## Usage

```hcl
module "cloud-ep-dns" {
  source      = "terraform-google-modules/endpoints-dns/google"
  project     = "${data.google_client_config.current.project}"
  name        = "myservice"
  external_ip = "${google_compute_instance.default.network_interface.0.access_config.0.assigned_nat_ip}"
}
```
