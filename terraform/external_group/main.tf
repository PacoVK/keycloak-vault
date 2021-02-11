#------------------------------------------------------------------------------#
# Vault policy
#------------------------------------------------------------------------------#

data "vault_policy_document" "policy" {
  count = length(var.groups)

  dynamic "rule" {
    for_each = var.groups[count.index].rules
    content {
      path = rule.value.path
      capabilities = rule.value.capabilities
    }
  }
}

resource "vault_policy" "policy" {
  count = length(var.groups)
  name   = var.groups[count.index].group_name
  policy = data.vault_policy_document.policy[count.index].hcl
}

#------------------------------------------------------------------------------#
# Vault external group - reader
#------------------------------------------------------------------------------#

resource "vault_identity_oidc_role" "role" {
  count = length(var.groups)
  name = var.groups[count.index].group_name
  key  = var.vault_identity_oidc_key_name
}

resource "vault_identity_group" "group" {
  count = length(var.groups)
  name     = vault_identity_oidc_role.role[count.index].name
  type     = "external"
  policies = [
    vault_policy.policy[count.index].name
  ]
}

resource "vault_identity_group_alias" "reader_group_alias" {
  count = length(var.groups)
  name           = var.groups[count.index].group_name
  mount_accessor = var.external_accessor
  canonical_id   = vault_identity_group.group[count.index].id
}
