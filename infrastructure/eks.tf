module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name                         = "eks-sbraunovic-cluster"
  cluster_version                      = "1.29"
  cluster_endpoint_public_access_cidrs = ["37.0.71.30/32"]
  cluster_endpoint_public_access       = true
  cluster_endpoint_private_access      = true



  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets



  eks_managed_node_groups = {
    example = {
      min_size       = 1
      max_size       = 10
      desired_size   = 1
      ami_type       = "BOTTLEROCKET_x86_64"
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      iam_role_name  = "sbraunovic-eks-role"
      iam_role_additional_policies = {
        AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }


  enable_cluster_creator_admin_permissions = true

  access_entries = {
    git = {
      principal_arn = module.iam_iam-assumable-role-with-oidc.iam_role_arn
      policy_associations = {
        git = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSEditPolicy"
          access_scope = {
            namespaces = ["sbraunovic-omega"]
            type       = "namespace"
          }
        }
      }
    }
  }

  tags = {
    Owner = var.owner
  }
}