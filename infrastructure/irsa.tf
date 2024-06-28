module "vpc_cni_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "stefanb-vpc-cni"

  attach_vpc_cni_policy = true


  vpc_cni_enable_ipv4 = true

  oidc_providers = {
    main = {
      provider_arn               = module.iam_iam-github-oidc-provider.arn
      namespace_service_accounts = ["default:my-app", "canary:my-app"]
    }
  }
}

module "irsa_load_balancer" {
  source    = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  role_name = "task2-irsa-for-LB"

  attach_load_balancer_controller_policy = true

  oidc_providers = {
    one = {
      provider_arn               = module.iam_iam-github-oidc-provider.arn
      namespace_service_accounts = ["vegait-load-balancer:load-balancer"]
    }
  }
}
