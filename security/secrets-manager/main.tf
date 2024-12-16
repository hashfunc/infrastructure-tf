module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.0"

  for_each = {
    for secret in var.secrets : secret.name => secret
  }

  name        = each.value.name
  description = each.value.description

  secret_string         = "{}"
  ignore_secret_changes = true
}
