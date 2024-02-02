provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "google_compute_backend_service" "example" {
  name        = var.backend_service_name
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 10
  enable_cdn  = false

  health_checks = [google_compute_health_check.example.name]

  backend {
    group = "dev-mig-simple-mig"  # Change this to your backend instance group
  }
}

resource "google_compute_health_check" "example" {
  name               = var.health_check_name
  check_interval_sec = 10
  timeout_sec        = 5
  http_health_check {
    port               = 80
    request_path       = var.health_check_path
    check_interval_sec = 10
    timeout_sec        = 5
  }
}

resource "google_compute_forwarding_rule" "example" {
  name                  = var.forwarding_rule_name
  load_balancing_scheme = "EXTERNAL"
  region                = var.region
  ip_protocol           = "TCP"
  port_range            = "80-80"

  backend_service = google_compute_backend_service.example.self_link
}

resource "google_compute_url_map" "example" {
  name = var.url_map_name

  default_route_action {
    cors_policy {
      max_age_seconds = 0
    }
    timeout_action {
      timeout_ms = 10000
    }
    url_rewrite {
      path_prefix_rewrite = "/new-path-prefix"
    }
    weighted_backend_services {
      backend_service = google_compute_backend_service.example.self_link
      weight          = 100
    }
  }
}

resource "google_compute_target_http_proxy" "example" {
  name        = var.target_proxy_name
  url_map     = google_compute_url_map.example.self_link
  description = "Example HTTP Proxy"
}

resource "google_compute_global_forwarding_rule" "example" {
  name                  = var.global_forwarding_rule_name
  ip_protocol           = "TCP"
  port_range            = "80-80"
  target                = google_compute_target_http_proxy.example.self_link
  load_balancing_scheme = "EXTERNAL"
}