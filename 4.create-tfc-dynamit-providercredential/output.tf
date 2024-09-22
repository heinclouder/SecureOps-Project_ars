output "bound_claim"{
    description = "Vault JWT Auth Backend Role's bound_claim"
    value = vault_jwt_auth_backend_role.secureops_jwt_backend_role.bound_claims
}

output "rolename"{
    description = "Vault JWT Auth Backend Role's role_name"
    value = vault_jwt_auth_backend_role.secureops_jwt_backend_role.role_name
}