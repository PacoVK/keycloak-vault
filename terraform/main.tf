terraform {
  required_version = ">= 0.13"

  required_providers {
    vault = {
      source = "hashicorp/vault"
    }
    keycloak = {
      source  = "mrparkers/keycloak"
      version = ">= 2.0.0"
    }
  }
}

variable "vault_oidc_discovery_url_host" {
  type = string
  default = "localhost"
}

locals {
  // values from docker-compose.yml
  vault_root_token = "myroot"
  keycloak_user = "root"
  keycloak_password = "root"
}

provider "vault" {
  address = "http://localhost:8200"
  token   = local.vault_root_token
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = local.keycloak_user
  password  = local.keycloak_password
  url       = "http://localhost:8080"
}
