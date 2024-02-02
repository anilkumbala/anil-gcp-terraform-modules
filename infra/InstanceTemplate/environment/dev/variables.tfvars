region = "asia-south1"
project_id      = "excellent-guide-410011"
env             = "dev"
service_account = {
  email  = "940391681103-compute@developer.gserviceaccount.com"
  scopes = ["https://www.googleapis.com/auth/compute",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring.write",
    "https://www.googleapis.com/auth/devstorage.full_control"]
}
subnetwork = "default"
machine_type = "e2-medium"
tags = ["http-server", "https-server"]