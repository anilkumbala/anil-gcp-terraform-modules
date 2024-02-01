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

module "instance_template" {
  source  = "../../modules/instance_template"
  
  name_prefix        = "${var.env}-mig"
  project_id         = var.project_id
  subnetwork         = var.subnetwork
  service_account    = var.service_account
  subnetwork_project = var.project_id
  machine_type            = var.machine_type
}

module "mig" {
  source  = "../../modules/managed_instance_group"
  project_id        = var.project_id
  region            = var.region
  target_size       = var.target_size
  hostname          = "${var.env}-mig-simple"
  instance_template = module.instance_template.self_link
}