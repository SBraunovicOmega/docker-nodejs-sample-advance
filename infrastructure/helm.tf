resource "helm_release" "load_balancer_controller" {
  name             = "stefan-loadbalancer-controller"
  repository       = "https://aws.github.io/eks-charts"
  chart            = "aws-load-balancer-controller"
  namespace        = "vegait-load-balancer"
  create_namespace = true
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
  set {
    name  = "primary.persistence.storageClass"
    value = kubernetes_storage_class.storage_class.metadata[0].name
  }
}




resource "kubernetes_storage_class" "storage_class" {
  metadata {
    name = "storage-class"
  }
  storage_provisioner = "ebs.csi.aws.com"
  volume_binding_mode = "WaitForFirstConsumer"

  parameters = {
    "encrypted" = "true"
  }
}

resource "helm_release" "bitnami_psql" {
  name       = "stefan-binami-psgl"
  repository = "oci://registry-1.docker.io/bitnamicharts/postgresql"
  chart      = "my-release"
  namespace  = "vegait-training"
  version    = "~> 16.3.0"

  set {
    name  = "primary.persistence.enabled"
    value = "true"
  }
  set {
    name  = "primary.persistence.volumeName"
    value = "psql-pvc-volume"
  }
  set {
    name  = "primary.persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }
  set {
    name  = "auth.username"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "username", "Error")
  }
  set {
    name  = "auth.password"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "password", "Error")
  }
  set {
    name  = "auth.database"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "dbname", "Error")
  }
  set {
    name  = "containerPorts.postgresql"
    value = lookup(jsondecode(sensitive(data.aws_secretsmanager_secret_version.secrets.secret_string)), "port", "Error")
  }
  set {
    name  = "primary.persistence.storageClass"
    value = kubernetes_storage_class.storage_class.metadata[0].name
  }
}
