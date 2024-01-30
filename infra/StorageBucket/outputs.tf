







output "network" {
  value       = try(module.networking[0].network, null)
  description = "The network to which TFE is attached."
}

output "service_account" {
  value       = module.service_accounts.service_account
  description = "The service account associated with the TFE instance."
}

output "subnetwork" {
  value       = try(module.networking[0].subnetwork, null)
  description = "The subnetwork to which TFE is attached."
}

output "dns_configuration_notice" {
  value       = "If you are using external DNS, please make sure to create a DNS record using the lb_address output that has been provided"
  description = "A warning message."
}

output "vm_mig" {
  value       = module.vm_mig
  description = "The managed instance group module."
}
