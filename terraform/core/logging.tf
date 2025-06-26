resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"

  version    = "0.49.1"
  values     = [file("${path.module}/config/values/fluent.values.yaml")]
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"

  version    = "6.30.1"
  values     = [file("${path.module}/config/values/loki.values.yaml")]
}
