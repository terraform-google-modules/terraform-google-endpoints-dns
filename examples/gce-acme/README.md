# Cloud Endpoints DNS ACME Example

[![button](http://gstatic.com/cloudssh/images/open-btn.png)](https://console.cloud.google.com/cloudshell/open?git_repo=https://github.com/terraform-google-modules/terraform-google-endpoints-dns&working_dir=examples/gce-acme&page=shell&tutorial=README.md)

<a href="https://concourse-tf.gcp.solutions/teams/main/pipelines/tf-examples-ep-dns-gce-acme" target="_blank">
<img src="https://concourse-tf.gcp.solutions/api/v1/teams/main/pipelines/tf-examples-ep-dns-gce-acme/badge" /></a>

This example shows how to create an ACME generated SSL certificate for a GCE instance with a Cloud Endpoints DNS record.

## Change to the example directory

```
[[ `basename $PWD` != gce-acme ]] && cd gce-acme
```

## Install Terraform

1. Install Terraform if it is not already installed (visit [terraform.io](https://terraform.io) for other distributions):

```
../terraform-install.sh
```

## Set up the environment

1. Set the project, replace `YOUR_PROJECT` with your project ID:

```
PROJECT=YOUR_PROJECT
```

```
gcloud config set project ${PROJECT}
```

2. Configure the environment for Terraform:

```
[[ $CLOUD_SHELL ]] || gcloud auth application-default login
export GOOGLE_PROJECT=$(gcloud config get-value project)
```

## Create terraform.tfvars file

1. Add your ACME notification email to the `terraform.tfvars` file: 

```
ACME_EMAIL=$(gcloud config get-value account)
echo "acme_email = \"${ACME_EMAIL}\"" > terraform.tfvars
cat terraform.tfvars
```

## Run Terraform

1. Run Terraform:

```
terraform init
terraform apply
```

## Testing

1. Wait for the instance to start with the ACME SSL certificate:

```
./test.sh
```

> This test can take 2-10 minutes to complete as the new DNS record is being propagated to the Cloud Shell instance.

## Cleanup

1. Remove all resources created by terraform:

```
terraform destroy
```