#------------------------------------------------------------------------------#
# OIDC client
#------------------------------------------------------------------------------#

resource "vault_identity_oidc_key" "keycloak_provider_key" {
  name      = "keycloak"
  algorithm = "RS256"
}

resource "vault_jwt_auth_backend" "keycloak" {
  path               = "oidc"
  type               = "oidc"
  default_role       = "default"
  oidc_discovery_url = format("http://keycloak:8080/realms/%s" ,keycloak_realm.realm.id)
  oidc_client_id     = keycloak_openid_client.openid_client.client_id
  oidc_client_secret = keycloak_openid_client.openid_client.client_secret

  tune {
    audit_non_hmac_request_keys  = []
    audit_non_hmac_response_keys = []
    default_lease_ttl            = "1h"
    listing_visibility           = "unauth"
    max_lease_ttl                = "1h"
    passthrough_request_headers  = []
    token_type                   = "default-service"
  }
}

resource "vault_jwt_auth_backend_role" "default" {
  backend        = vault_jwt_auth_backend.keycloak.path
  role_name      = "default"
  token_ttl      = 3600
  token_max_ttl  = 3600

  bound_audiences = [keycloak_openid_client.openid_client.client_id]
  user_claim      = "sub"
  claim_mappings = {
    preferred_username = "username"
    email              = "email"
  }
  role_type             = "oidc"
  allowed_redirect_uris = ["http://localhost:8200/ui/vault/auth/oidc/oidc/callback", "http://localhost:8250/oidc/callback"]
  groups_claim          = format("/resource_access/%s/roles",keycloak_openid_client.openid_client.client_id)
}

#------------------------------------------------------------------------------#
# Vault policies
#------------------------------------------------------------------------------#
module "reader" {
  source = "./external_group"
  external_accessor = vault_jwt_auth_backend.keycloak.accessor
  vault_identity_oidc_key_name = vault_identity_oidc_key.keycloak_provider_key.name
  groups = [
    {
      group_name = "reader"
      rules = [
        {
          path         = "/secret/*"
          capabilities = ["read", "list"]
        }
      ]
    }
  ]
}

module "management" {
  source = "./external_group"
  external_accessor = vault_jwt_auth_backend.keycloak.accessor
  vault_identity_oidc_key_name = vault_identity_oidc_key.keycloak_provider_key.name
  groups = [
    {
      group_name = "management"
      rules = [
        {
          path         = "/secret/*"
          capabilities = ["create", "update", "delete"]
        }
      ]
    }
  ]
}
