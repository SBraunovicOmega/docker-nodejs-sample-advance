resource "helm_release" "load_balancer_controller" {
  name             = "stefan-loadbalancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "vegait-training"
  create_namespace = true
  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }


  set {
    name  = "serviceAccount.name"
    value = "vegait-load-balancer"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.iam_iam-github-oidc-provider.arn
  }
  set {
    name  = "region"
    value = var.region
  }
  set {
    name  = "vpcId"
    value = module.vpc.vpc_id
  }
  set {
    name  = "defaultTargetType"
    value = "ip"
  }
}


resource "kubernetes_persistent_volume_claim" "postgres_pvc" {
  metadata {
    name      = "stefan-ps-db"
    namespace = "vegait-training"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
  }
}


resource "helm_release" "bitnami_psql" {
  name       = "stefan-binami-psgl"
  repository = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  chart      = "my-release"
  namespace  = "vegait-training"

  set {
    name  = "auth.username"
    value = "postgres"
  }
  set {
    name  = "auth.password"
    value = "postgres"
  }
  set {
    name  = "auth.database"
    value = "to-do"
  }
  set {
    name  = "containerPorts.postgresql"
    value = 5432
  }
  set {
    name  = "persistence.existingClaim"
    value = kubernetes_persistent_volume_claim.postgres_pvc.metadata[0].name
  }
}
