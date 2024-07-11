resource "helm_release" "load_balancer_controller" {
  name             = "stefan-loadbalancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "vegait-load-balancer"
  create_namespace = true



  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.irsa_load_balancer.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }


  set {
    name  = "serviceAccount.name"
    value = "load-balancer"
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




resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "stefan-storage-class"

  }
  depends_on             = [module.eks]
  reclaim_policy         = "Delete"
  storage_provisioner    = "ebs.csi.aws.com"
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true
  parameters = {
    "encrypted" = "true"
  }
}

resource "helm_release" "bitnamipsql" {
  name             = "stefan-postgresql"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "postgresql"
  version          = "15.3.2"
  create_namespace = true
  namespace        = "vegait-training"




  set {
    name  = "auth.username"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "username", "")
  }

  set {
    name  = "auth.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "password", "")
  }

  set {
    name  = "auth.database"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "dbname", "")
  }
  set {
    name  = "containerPorts.postgresql"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "port", "")
  }
  set {
    name  = "primary.persistence.enabled"
    value = true
  }
  set {
    name  = "primary.persistence.volumeName"
    value = "stefan-persistent-volume"
  }
  set {
    name  = "primary.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "primary.persistence.storageClass"
    value = kubernetes_storage_class.storage_class.metadata[0].name
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "primary.persistence.size"
    value = "8Gi"
  }
}


resource "helm_release" "todo_app" {
  name       = "stefan-todo"
  repository = join("", ["oci://", module.ecr.repository_registry_id, ".dkr.ecr.eu-central-1.amazonaws.com"])
  chart      = "private-ecr"
  version    = "0.1.0"
  namespace  = "vegait-training"

  set {
    name  = "label"
    value = "todo"
  }
  set {
    name  = "service.protocol"
    value = "TCP"
  }
  set {
    name  = "service.target_port"
    value = 3000
  }
  set {
    name  = "service.port"
    value = 443
  }
  set {
    name  = "ingress.class"
    value = "alb"
  }
  set {
    name  = "ingress.host"
    value = var.domain_name
  }
  set {
    name  = "ingress.path"
    value = "/"
  }
  set {
    name  = "ingress.path_type"
    value = "Prefix"
  }
  set {
    name  = "ingress.certificateArn"
    value = module.acm.acm_certificate_arn
  }

  set {
    name  = "secret.user"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "username", "")
  }
  set {
    name  = "secret.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "password", "")
  }
  set {
    name  = "secret.db"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "dbname", "")
  }
  set {
    name  = "configmap.port"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "port", 0)
  }
  set {
    name  = "configmap.host"
    value = "stefan-postgresql"
  }

  set {
    name  = "app.image"
    value = module.ecr.repository_url
  }

  set {
    name  = "app.replica_count"
    value = 1
  }
  set {
    name  = "app.port"
    value = 3000
  }

}
