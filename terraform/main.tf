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

locals {
  // values from docker-compose.yml
  vault_root_token = "myroot"
  keycloak_user = "root"
  keycloak_password = "root"
}

provider "vault" {
  // see docker-compose.yml
  address = "http://vault:8200"
  token   = local.vault_root_token
}

provider "keycloak" {
  client_id = "admin-cli"
  username  = local.keycloak_user
  password  = local.keycloak_password
  // see docker-compose.yml
  url       = "http://keycloak:8080"
}
