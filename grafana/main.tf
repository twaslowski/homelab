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

resource "grafana_dashboard" "pods" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/pods.json")
}

resource "grafana_dashboard" "namespaces" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/namespaces.json")
}

resource "grafana_dashboard" "cnpg" {
  folder = grafana_folder.cluster.uid
  config_json = file("${path.module}/dashboards/cnpg.json")
}
