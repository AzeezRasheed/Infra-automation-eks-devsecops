variable "aws_region" {
}

# variable "aws_access_key_id" {}
# variable "aws_secret_access_key" {}

variable "name" {
}


variable "k8s_version" {
}

variable "vpc_cidr_block" {
}
variable "private_subnet_cidr_blocks" {
}
variable "public_subnet_cidr_blocks" {
}

variable "user_for_admin_role" {}
variable "user_for_dev_role" {}

variable "kubernetes_cluster_enabled_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "A list of the desired control plane logging to enable"
}