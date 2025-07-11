variable "grafana_api_key" {
  description = "Service account token for Grafana API access"
  type        = string
  sensitive   = true
}

variable "grafana_url" {
  description = "URL of the Grafana instance"
  type        = string
  default     = "https://grafana.twaslowski.com"
}

variable "aws_access_key_id" {
  description = "AWS Access Key for CloudWatch data source"
  type        = string
  default     = ""
}

variable "aws_secret_access_key" {
  description = "AWS Secret Key for CloudWatch data source"
  type        = string
  default     = ""
}

variable "telegram_token" {
  description = "Telegram bot token for notifications"
  type        = string
  default     = ""
}

variable "telegram_chat_id" {
  description = "Telegram chat ID for notifications"
  type        = string
  default     = ""
}