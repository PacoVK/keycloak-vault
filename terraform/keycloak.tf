#------------------------------------------------------------------------------#
# Keycloak Basics
#------------------------------------------------------------------------------#

resource "keycloak_realm" "realm" {
  realm   = "demo-realm"
  enabled = true
}

resource "keycloak_user" "user_alice" {
  realm_id   = keycloak_realm.realm.id
  username   = "alice"
  enabled    = true

  email      = "alice@domain.com"
  first_name = "Alice"
  last_name  = "Aliceberg"

  initial_password {
    value     = "alice"
    temporary = false
  }
}

resource "keycloak_user_roles" "alice_roles" {
  realm_id = keycloak_realm.realm.id
  user_id  = keycloak_user.user_alice.id

  role_ids = [
    keycloak_role.reader_role.id
  ]
}

resource "keycloak_user" "user_bob" {
  realm_id   = keycloak_realm.realm.id
  username   = "bob"
  enabled    = true

  email      = "bob@domain.com"
  first_name = "Bob"
  last_name  = "Bobsen"

  initial_password {
    value     = "bob"
    temporary = false
  }
}

resource "keycloak_user_roles" "bob_roles" {
  realm_id = keycloak_realm.realm.id
  user_id  = keycloak_user.user_bob.id

  role_ids = [
    keycloak_role.management_role.id
  ]
}

#------------------------------------------------------------------------------#
# Keycloak Vault OIDC Client
#------------------------------------------------------------------------------#

resource "keycloak_openid_client" "openid_client" {
  realm_id            = keycloak_realm.realm.id
  client_id           = "vault"

  name                = "vault"
  enabled             = true
  standard_flow_enabled = true

  access_type         = "CONFIDENTIAL"
  valid_redirect_uris = [
    "http://localhost:8200/*"
  ]

  login_theme = "keycloak"
}

resource "keycloak_openid_user_client_role_protocol_mapper" "user_client_role_mapper" {
  realm_id   = keycloak_realm.realm.id
  client_id  = keycloak_openid_client.openid_client.id
  name       = "user-client-role-mapper"
  claim_name = format("resource_access.%s.roles",keycloak_openid_client.openid_client.client_id)
  multivalued = true
}

resource "keycloak_role" "management_role" {
  realm_id    = keycloak_realm.realm.id
  client_id   = keycloak_openid_client.openid_client.id
  name        = "management"
  description = "Management role"
  composite_roles = [
    keycloak_role.reader_role.id
  ]
}

resource "keycloak_role" "reader_role" {
  realm_id    = keycloak_realm.realm.id
  client_id   = keycloak_openid_client.openid_client.id
  name        = "reader"
  description = "Reader role"
}
