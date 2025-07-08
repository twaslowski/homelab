resource "helm_release" "postgres_operator" {
  chart = "${path.module}/../../charts/postgres"
  name  = "postgres-2"

  namespace = ""
}