resource "kubernetes_service_account" "runner_service_account" {
  metadata {
    name      = "arc-runner-sa"
    namespace = kubernetes_namespace_v1.arc_runner.metadata[0].name
  }
}

resource "kubernetes_cluster_role" "runner_role" {
  metadata {
    name = "runner-role"
  }

  rule {
    api_groups = ["*"]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

resource "kubernetes_cluster_role_binding" "runner_role_binding" {
  metadata {
    name = "runner-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.runner_role.metadata[0].name
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.runner_service_account.metadata[0].name
    namespace = kubernetes_service_account.runner_service_account.metadata[0].namespace
  }
}