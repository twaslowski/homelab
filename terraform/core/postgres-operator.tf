resource "helm_release" "postgres_operator" {
  name  = "postgres-operator"
  chart = "../../charts/pgo"
  namespace = "postgres-operator"
  create_namespace = true

  values = [file("${path.module}/config/values/postgres-operator.values.yaml")]
}