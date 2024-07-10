module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "private-ecr"


  repository_read_write_access_arns = [module.iam_iam-assumable-role-with-oidc.iam_role_arn]
  repository_image_tag_mutability   = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform = "true"
  }
}


