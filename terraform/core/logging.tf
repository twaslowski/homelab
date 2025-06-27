resource "kubernetes_namespace_v1" "logging" {
  metadata {
    name = "logging"
  }
}

resource "helm_release" "fluent_bit" {
  name       = "fluent-bit"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluent-bit"
  namespace = kubernetes_namespace_v1.logging.metadata[0].name

  version = "0.49.1"
  values = [file("${path.module}/config/values/fluent.values.yaml")]
}

resource "helm_release" "loki" {
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki"
  namespace = kubernetes_namespace_v1.logging.metadata[0].name

  version = "6.30.1"
  values = [file("${path.module}/config/values/loki.values.yaml")]
}
