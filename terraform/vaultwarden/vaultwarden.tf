resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "vaultwarden"
  }
}

resource "helm_release" "vaultwarden" {
  depends_on = [helm_release.postgres]

  name       = "vaultwarden"
  repository = "https://guerzon.github.io/vaultwarden"
  chart      = "vaultwarden"
  version    = "0.32.1"

  namespace        = kubernetes_namespace_v1.namespace.metadata[0].name
  create_namespace = true

  values = [file("${path.module}/config/values/vaultwarden.values.yaml")]

  wait    = true
  timeout = 120
}
