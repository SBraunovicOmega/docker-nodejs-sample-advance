module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "~> 1.1.2"
  name    = "psql-credentials-stefan"

  ignore_secret_changes = true
  secret_string = jsonencode({
    username = ""
    password = ""
    dbname   = ""
    port     = 0
  })
}

data "aws_secretsmanager_secret_version" "secrets" {
  depends_on = [module.secrets_manager]
  secret_id  = module.secrets_manager.secret_id
}
