variable "region" {
  default = "ap-southeast-2"
}

variable "application_name" {
  type    = string
  default = "terramino"
}

# export TF_VAR_slack_app_token="xoxb-425751542688-2479332781409-BzOhCdCceGLQz98NWKgzM9BK"
variable "slack_app_token" {
  type        = string
  description = "Slack App Token"
}

