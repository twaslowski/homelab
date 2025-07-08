resource "helm_release" "postgres" {
  name       = "postgres"
  chart      = "postgrescluster"
  repository = "https://twaslowski.github.io/homelab"
  version    = "5.7.5"

  values = [file("${path.module}/config/values/postgres.values.yaml")]

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
}