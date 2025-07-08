resource "kubernetes_namespace_v1" "namespace" {
  metadata {
    name = "vaultwarden"
  }
}

locals {
  datasource_password = "fc89fe9f62c778dd874e9fffb3d2c3be"
}

resource "helm_release" "vaultwarden" {
  depends_on = [helm_release.postgres]

  name       = "vaultwarden"
  repository = "https://guerzon.github.io/vaultwarden"
  chart      = "vaultwarden"
  version    = "0.32.1"

  namespace        = kubernetes_namespace_v1.namespace.metadata[0].name
  create_namespace = true

  values = [templatefile("${path.module}/config/values/vaultwarden.values.yaml", {
    vaultwarden_postgres_password = local.datasource_password
  })]

  wait    = true
  timeout = 180
}

resource "helm_release" "postgres" {
  name = "postgres"

  chart     = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
  version   = "16.7.14"

  timeout = 300
  wait    = true

  values = [
    templatefile("${path.module}/config/values/postgres.values.yaml", {
      vaultwarden_postgres_password = local.datasource_password
    })
  ]
}