variable "project_id" {
  description = "The GCP project to use for integration tests"
  type        = string
}
variable "env" {
  description = "The GCP project to use for integration tests"
  type        = string
}

variable "region" {
  description = "The GCP region to create and test resources in"
  type        = string
  default     = ""
}

variable "subnetwork" {
  description = "The subnetwork to host the compute instances in"
}

variable "target_size" {
  description = "The target number of running instances for this managed instance group. This value should always be explicitly set unless this resource is attached to an autoscaler, in which case it should never be set."
  type        = number
}

variable "service_account" {
  default = null
  type = object({
    email  = string
    scopes = set(string)
  })
  description = "Service account to attach to the instance. See https://www.terraform.io/docs/providers/google/r/compute_instance_template#service_account."
}
variable "machine_type" {
  description = "Machine type to create, e.g. n1-standard-1"
  type        = string
  default     = ""
}
