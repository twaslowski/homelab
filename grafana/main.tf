resource "grafana_folder" "cluster" {
  title = "cluster"
}

resource "grafana_dashboard" "global" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/global.json")
}

resource "grafana_dashboard" "node" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/node.json")
}

resource "grafana_dashboard" "flux" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/flux.json")
}