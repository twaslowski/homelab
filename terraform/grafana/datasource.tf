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

  is_default = true
}
