#JWT backen enable in HCP
resource "vault_jwt_auth_backend" "secureops-jwt-backend" {
    description         = "Demonstration of the Terraform JWT auth backend"
    path                = "jwt"
    oidc_discovery_url  = "https://app.terraform.io"
    bound_issuer        = "https://app.terraform.io"
}

resource "vault_policy" "admin-policy" {
  name = "admin-policy"
  
  policy = <<EOT
# Allow tokens to query themselves
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

# Allow tokens to renew themselves
path "auth/token/renew-self" {
    capabilities = ["update"]
}

# Allow tokens to revoke themselves
path "auth/token/revoke-self" {
    capabilities = ["update"]
}

path "sys/mounts" {
  capabilities = ["list", "read"]
}

path "sys/mounts/example" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}

path "example/*" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}

path "sys/mounts/example" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}
path "example/*" {
  capabilities = ["create", "read", "update", "patch", "delete", "list"]
}

EOT
}


resource "vault_jwt_auth_backend_role" "secureops_jwt_backend_role" {
  backend         = vault_jwt_auth_backend.secureops-jwt-backend.path
  role_name       = "vault-jwt-auth-role"
  token_policies  = [vault_policy.admin-policy.name]
  bound_audiences = ["vault.workload.identity"]
  bound_claims_type = "glob"
  bound_claims= {
    sub: "organization:ars_secureOps_prj:project:ars_secureOps_project:workspce:*:run_phase:apply"
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"
  token_ttl       = 1200
}