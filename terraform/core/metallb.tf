resource "helm_release" "metal_lb" {
  name       = "metallb"

  repository = "https://metallb.github.io/metallb"
  chart      = "metallb"
  namespace  = "kube-system"

  version    = "0.15.2"
}