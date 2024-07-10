module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 4.0"

  domain_name = var.domain_name
  zone_id     = var.zone_id

  validation_method = "DNS"


  wait_for_validation = true
  tags = {
    Owner = var.owner
  }
}



data "aws_lb" "load_balancer_source" {
  name = "k8s-vegaittr-stefanto-b449e430c9"
}






resource "aws_route53_record" "todo_app" {
  zone_id = var.zone_id /*  */
  name    = "sbraunovic.omega.devops.sitesstage.com"
  type    = "A"

  alias {
    name                   = data.aws_lb.load_balancer_source.dns_name
    zone_id                = data.aws_lb.load_balancer_source.zone_id
    evaluate_target_health = true
  }
}


data "kubernetes_service" "data_load_balancer" {
  metadata {
    name      = helm_release.load_balancer_controller.name
    namespace = helm_release.load_balancer_controller.namespace
  }
}


