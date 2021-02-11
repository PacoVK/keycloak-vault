variable "groups" {
  type = list(object({
    group_name = string
    rules = set(object({
      path = string
      capabilities = list(string)
    }))
  }))
}

variable "vault_identity_oidc_key_name" {
  type = string
}

variable "external_accessor" {}
