resource "kubernetes_namespace_v1" "arc_runner" {
  metadata {
    name = "arc-runners"
  }
}

resource "kubernetes_namespace_v1" "arc_system" {
  metadata {
    name = "arc-systems"
  }
}

resource "helm_release" "arc" {
  name      = "arc"
  namespace = kubernetes_namespace_v1.arc_system.metadata[0].name

  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = "0.12.0"

  create_namespace = true
}

resource "helm_release" "arc_runner_scale_set" {
  for_each = toset(local.github_projects)
  depends_on = [helm_release.arc]

  name      = "arc-runner-${each.key}"
  namespace = kubernetes_namespace_v1.arc_runner.metadata[0].name

  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.12.0"

  create_namespace = true

  set = [
    {
      name  = "githubConfigSecret.github_token"
      value = var.github_token
    },
    {
      name  = "githubConfigUrl"
      value = "https://github.com/twaslowski/${each.value}"
    },
    {
      name  = "template.spec.serviceAccountName"
      value = kubernetes_service_account.runner_service_account.metadata[0].name
    }
  ]
}
