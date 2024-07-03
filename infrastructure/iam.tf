module "iam_iam-assumable-role-with-oidc" {
  source = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"

  create_role                    = true
  role_name                      = "sbraunovic-aws-oidc"
  provider_url                   = module.iam_iam-github-oidc-provider.url
  number_of_role_policy_arns     = 1
  oidc_fully_qualified_audiences = ["sts.amazonaws.com"]
  role_policy_arns               = [module.iam_iam-policy.arn]
  oidc_subjects_with_wildcards   = [var.github_repo]
  tags                           = var.omega
}

module "iam_iam-github-oidc-provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-github-oidc-provider"
  tags   = var.omega
}




module "iam_iam-policy" {
  source = "terraform-aws-modules/iam/aws//modules/iam-policy"

  name = "oidc-github-stefanb-iam-policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
            "ecr:CompleteLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:InitiateLayerUpload",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage"
      ],
         "Resource": "${module.ecr.repository_arn}"
    },
        {
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
    
    {
      "Effect": "Allow",
      "Action": [
        "eks:AccessKubernetesApi",
        "eks:CreateCluster",
        "eks:DescribeCluster",
        "eks:ListClusters",
        "eks:ListUpdates",
        "eks:UpdateClusterConfig",
        "eks:UpdateClusterVersion"
      ],
      "Resource": "*"
    }
  ]
}
EOF

  tags = var.tags
}


