output "secrets" {
  value = {
    for secret in module.secrets_manager :
    secret.secret_name => {
      name = secret.secret_name
      arn  = secret.secret_arn
    }
  }
}
