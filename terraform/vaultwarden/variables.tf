variable "aws_access_key_id" {
  description = "AWS Access Key ID for performing backrest backups"
  type        = string
  sensitive   = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key for performing backrest backups"
  type        = string
  sensitive   = true
}

variable "backrest_backup_bucket" {
  description = "Name of the S3 bucket for backrest backups"
  type        = string
  default     = "246770851643-homelab-backrest-backups"
}