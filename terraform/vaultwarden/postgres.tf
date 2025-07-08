resource "helm_release" "postgres" {
  name       = "postgres"
  chart      = "../../charts/postgres-cluster"
  repository = "https://twaslowski.github.io/homelab"
  version    = "0.3.2"

  values = [
    templatefile("${path.module}/config/values/postgres.values.yaml", {
      backup_bucket_name    = var.backrest_backup_bucket
      aws_access_key_id     = var.aws_access_key_id
      aws_secret_access_key = var.aws_secret_access_key
    })
  ]

  namespace = kubernetes_namespace_v1.namespace.metadata[0].name
}