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