variable "project_id" {
  description = "Google Cloud Project ID"
  type        = string
}

variable "region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"  # Change this to your desired GCP region
}

variable "backend_service_name" {
  description = "Name of the backend service"
  type        = string
  default     = "example-backend-service"
}

variable "backend_instance_group" {
  description = "Name of the backend instance group"
  type        = string
  default     = "instance-group-1"  # Change this to your backend instance group
}

variable "health_check_name" {
  description = "Name of the health check"
  type        = string
  default     = "example-health-check"
}

variable "health_check_path" {
  description = "Path used for health checks"
  type        = string
  default     = "/health"  # Change this to the path you want to use for health checks
}

variable "forwarding_rule_name" {
  description = "Name of the forwarding rule"
  type        = string
  default     = "example-forwarding-rule"
}

variable "url_map_name" {
  description = "Name of the URL map"
  type        = string
  default     = "example-url-map"
}

variable "target_proxy_name" {
  description = "Name of the target HTTP proxy"
  type        = string
  default     = "example-target-http-proxy"
}

variable "global_forwarding_rule_name" {
  description = "Name of the global forwarding rule"
  type        = string
  default     = "example-global-forwarding-rule"
}