resource "helm_release" "cloudflare_tunnel_ingress_controller" {
  name = "cloudflare-tunnel-ingress-controller"

  repository = "https://helm.strrl.dev"
  chart      = "cloudflare-tunnel-ingress-controller"
  version    = "0.0.18"

  namespace        = "cloudflare-tunnel-ingress-controller"
  create_namespace = true

  set = [
    {
      name  = "cloudflare.tunnelName"
      value = var.cloudflare_tunnel_name
    }
  ]

  set_sensitive = [
    {
      name  = "cloudflare.apiToken"
      value = var.cloudflare_api_token
    },
    {
      name  = "cloudflare.accountId"
      value = var.cloudflare_account_id
    },
  ]
}
