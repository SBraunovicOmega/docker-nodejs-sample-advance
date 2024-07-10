variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "owner" {
  type    = string
  default = "Stefan Braunovic"
}

variable "tags" {
  type = map(string)
  default = {
    "Owner" = "Stefan Braunovic"
  }
}


variable "omega" {
  type = map(string)
  default = {
    "Owner" = "Omega"
  }
}

variable "base_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}



variable "github_repo" {
  type    = string
  default = "repo:sbraunovicomega/docker-nodejs-sample-advance*"
}


variable "domain_name" {
  type    = string
  default = "sbraunovic.omega.devops.sitesstage.com"
}
variable "zone_id" {
  type    = string
  default = "Z07475403IQFN5IUZ6XJ9"

}




