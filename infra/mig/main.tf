 terraform {
  backend "gcs" {
    bucket = var.bucket # GCS bucket name to store terraform tfstate
    prefix = var.prefix              # Prefix name should be unique for each Terraform project having same remote state bucket.
  }
}

provider "google" {
  region = var.region
}

provider "google-beta" {
  region = var.region
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
  name_prefix                  = "anil-${var.env}-instance-template-mig"
  machine_type                 = var.machine_type
  tags                         = var.tags
  labels                       = var.labels
  access_config                = [local.access_config]
  enable_nested_virtualization = var.enable_nested_virtualization
  threads_per_core             = var.threads_per_core

}

resource "google_compute_firewall" "allow-http" {
  name    = "${var.env}-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [80]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
}

resource "google_compute_firewall" "allow-https" {
  name    = "${var.env}-allow-https"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [443]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
}

resource "google_compute_firewall" "allow-load-balancer" {
  name    = "${var.env}-allow-load-balancer"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = [80, 443]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server", "lb-http-https-server"]
}



module "mig" {
  source  = "../../modules/managed_instance_group"
  project_id        = var.project_id
  region            = var.region
  target_size       = var.target_size
  hostname          = "${var.env}-mig-simple"
  instance_template = module.instance_template.self_link
}

