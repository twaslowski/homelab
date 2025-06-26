resource "helm_release" "grafana" {
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  version    = "9.2.7"

  namespace        = "grafana"
  create_namespace = true

  values = [file("${path.module}/config/values/grafana.values.yaml")]
}
