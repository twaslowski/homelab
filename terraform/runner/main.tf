resource "helm_release" "arc" {
  name      = "arc"
  namespace = "arc-systems"

  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set-controller"
  version    = "0.12.0"

  create_namespace = true
}

resource "helm_release" "arc_runner_scale_set" {
  for_each  = toset(local.github_projects)
  name      = "arc-runner-${each.key}"
  namespace = "arc-runners"

  repository = "oci://ghcr.io/actions/actions-runner-controller-charts"
  chart      = "gha-runner-scale-set"
  version    = "0.12.0"

  create_namespace = true

  set_wo {
    name  = "githubConfigSecret.github_token"
    value = var.github_token
  }

  set {
    name  = "githubConfigUrl"
    value = "https://github.com/twaslowski/${each.value}"
  }
}
