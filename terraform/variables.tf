variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west9"
}

variable "zone" {
  type    = string
  default = "europe-west9-b"
}

variable "ssh_user" {
  type    = string
  default = "user"
}
