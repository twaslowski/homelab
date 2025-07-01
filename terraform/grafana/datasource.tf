resource "grafana_data_source" "prometheus" {
  name = "prometheus"
  type = "prometheus"
  url  = "http://prometheus-server.prometheus.svc.cluster.local"

  is_default = true
}

resource "grafana_data_source" "loki" {
  name = "loki"
  type = "loki"
  url  = "http://loki-gateway.logging.svc.cluster.local:80"
}

resource "grafana_data_source" "cloudwatch" {
  type = "cloudwatch"
  name = "cloudwatch"

  json_data_encoded = jsonencode({
    defaultRegion = "eu-central-1"
    authType      = "keys"
  })

  secure_json_data_encoded = jsonencode({
    accessKey = var.aws_access_key_id
    secretKey = var.aws_secret_access_key
  })
}