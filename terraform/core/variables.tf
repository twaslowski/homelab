variable "cloudflare_api_token" {
  description = "Cloudflare API token with required permissions."
  type        = string
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID."
  type        = string
}

variable "cloudflare_tunnel_name" {
  description = "Name of the Cloudflare Tunnel. Will be created if it doesn't exist."
  type        = string
  default     = "homelab-tunnel"
}
