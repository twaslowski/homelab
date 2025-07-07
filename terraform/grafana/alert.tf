resource "grafana_contact_point" "email" {
  name = "personal"

  # does not work unless smtp is configured
  # email {
  #   addresses               = ["contact@twaslowski.com"]
  #   message                 = "{{ len .Alerts.Firing }} firing."
  #   subject                 = "{{ template \"default.title\" .}}"
  #   single_email            = true
  #   disable_resolve_message = false
  # }

  telegram {
    chat_id = var.telegram_chat_id
    token   = var.telegram_token
  }
}