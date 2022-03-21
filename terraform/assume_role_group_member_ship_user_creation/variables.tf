variable "username" {
  description = "This is the username you want to create with the terraform automation."
  default     = "prod-automation-user"
}

variable "role_group_name" {
  description = "This is the role/group/policy-names for the prod user. "
  default     = "prod-ci"
}
