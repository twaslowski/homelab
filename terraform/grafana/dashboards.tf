resource "grafana_folder" "infrastructure" {
  title = "Infrastructure"
}

resource "grafana_dashboard" "global" {
  config_json = file("${path.module}/dashboards/global.json")
  folder      = grafana_folder.infrastructure.id
}

resource "grafana_dashboard" "nodes" {
  config_json = file("${path.module}/dashboards/nodes.json")
  folder      = grafana_folder.infrastructure.id
}