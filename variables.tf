variable "aws_auth_map_users" {

  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))

  description = "values for mapUsers in aws-auth configmap"
}