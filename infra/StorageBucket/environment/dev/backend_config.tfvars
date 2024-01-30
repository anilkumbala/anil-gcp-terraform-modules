terraform {
  backend "gcs" {
    bucket = "anil-terraform-statefiles" # GCS bucket name to store terraform tfstate
    prefix = "modules/dev/StorageBucket"               # Prefix name should be unique for each Terraform project having same remote state bucket.
  }
}