resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "prometheus"

  version          = "27.22.0"
  namespace        = "prometheus"
  create_namespace = true
}
