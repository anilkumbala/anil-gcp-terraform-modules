 terraform {
  backend "gcs" {
    bucket = var.bucket # GCS bucket name to store terraform tfstate
    prefix = var.prefix              # Prefix name should be unique for each Terraform project having same remote state bucket.
  }
}
provider "google" {

  project = var.project_id
  region  = var.region
}

resource "google_compute_address" "ip_address" {
  name = "${var.env}-external-ip-2"
}

locals {
  access_config = {
    nat_ip       = google_compute_address.ip_address.address
    network_tier = "PREMIUM"
  }
}

module "instance_template" {
  source  = "../../modules/instance_template"
  project_id                   = var.project_id
  subnetwork                   = var.subnetwork
  stack_type                   = "IPV4_ONLY"
  service_account              = var.service_account
  name_prefix                  = "anil-${var.env}-instance-template"
  machine_type                 = var.machine_type
  tags                         = var.tags
  labels                       = var.labels
  access_config                = [local.access_config]
  enable_nested_virtualization = var.enable_nested_virtualization
  threads_per_core             = var.threads_per_core

}