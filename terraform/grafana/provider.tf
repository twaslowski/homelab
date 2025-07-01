terraform {
  backend "kubernetes" {
    secret_suffix = "grafana"
    namespace     = "grafana"
    config_path   = "~/.kube/config"
  }

  required_providers {
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.0"
    }
  }
}

provider "grafana" {
  url  = var.grafana_url
  auth = var.grafana_api_key
}