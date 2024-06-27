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

variable "base_cidr_block" {
  type    = string
  default = "172.16.0.0/16"
}



variable "github_repo" {
  type    = string
  default = "repo:sbraunovicomega/docker-nodejs-sample-advance*"
}

