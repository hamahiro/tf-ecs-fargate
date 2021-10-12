# variable.tf

variable "vpc" {
  type = object({
    cidr       = string
    az_c       = string
    az_d       = string
    pub_c_cidr = string
    pub_d_cidr = string
    pri_c_cidr = string
    pri_d_cidr = string
    db_c_cidr  = string
    db_d_cidr  = string
  })
  default = {
    cidr       = "10.0.0.0/16"
    az_c       = "ap-northeast-1c"
    az_d       = "ap-northeast-1d"
    pub_c_cidr = "10.0.3.0/24"
    pub_d_cidr = "10.0.4.0/24"
    pri_c_cidr = "10.0.103.0/24"
    pri_d_cidr = "10.0.104.0/24"
    db_c_cidr  = "10.0.203.0/24"
    db_d_cidr  = "10.0.204.0/24"
  }
}

