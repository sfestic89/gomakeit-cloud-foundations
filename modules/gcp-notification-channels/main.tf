/*
You can get the list of valid labels with "gcloud beta monitoring channel-descriptors describe TYPE"
eg gcloud beta monitoring channel-descriptors describe slack

*/

resource "google_monitoring_notification_channel" "email_notification_channels" {
  for_each = try({for mail in var.notification_channels.email: mail.display_name => mail.contact},{})
  project = var.project_id
  type    = "email"
  labels = {
    "email_address" = each.value
  }
  display_name = each.key
}

resource "google_monitoring_notification_channel" "sms_notification_channels" {
  for_each = try({for sms in var.notification_channels.sms: sms.display_name => sms.contact},{})
  project = var.project_id
  type    = "sms"
  labels = {
    "number" = each.value
  }
  display_name = each.key
}

resource "google_monitoring_notification_channel" "slack_notification_channels" {
  for_each = try({for slack in var.notification_channels.slack: slack.display_name => slack},{})
  project = var.project_id
  type    = "slack"
  /*
  - description: A permanent authentication token provided by Slack. This field is obfuscated
    by returning only a few characters of the key when fetched.
  key: auth_token
  - description: The Slack channel to which to post notifications.
    key: channel_name
  - description: The Slack team name. This label is for output only.
    key: team
  */
  labels = {
    "channel_name" = each.value.channel_name
  }

  sensitive_labels {
    auth_token = each.value.auth_token
  }

  display_name = each.key

}

resource "google_monitoring_notification_channel" "pubsub_notification_channels" {
  for_each = try({for pubsub in var.notification_channels.pubsub: pubsub.display_name => pubsub.contact},{})
  project = var.project_id
  type    = "pubsub"
  labels = {
    "topic" = each.value
  }
  display_name = each.key
}

resource "google_monitoring_notification_channel" "webhook_basicauth_notification_channels" {
  for_each = try({for webhook_basicauth in var.notification_channels.webhook_basicauth: webhook_basicauth.display_name => webhook_basicauth},{})
  project = var.project_id
  type    = "webhook_basicauth"
  /*
  - description: The password. The field is obfuscated when the channel is fetched.
  key: password
  - description: The URL to which to publish the webhook.
    key: url
  - description: The username.
    key: username
  */
  sensitive_labels {
    password = each.value.password
  }
  labels = {
    "url" = each.value.url
  }
  display_name = each.key
}

resource "google_monitoring_notification_channel" "webhook_tokenauth_notification_channels" {
  for_each = try({for webhook_tokenauth in var.notification_channels.webhook_tokenauth: webhook_tokenauth.display_name => webhook_tokenauth.contact},{})
  project = var.project_id
  type    = "pagerduty"
  /*
  - description: The URL to which to publish the webhook.
  key: url
  */
  labels = {
    "url" = each.value
  }
  display_name = each.key
}