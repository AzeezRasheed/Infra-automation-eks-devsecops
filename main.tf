module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = var.name
  cidr = var.vpc_cidr_block

  azs             = data.aws_availability_zones.azs.names
  private_subnets = var.private_subnet_cidr_blocks
  public_subnets  = var.public_subnet_cidr_blocks

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = local.public_subnet_tags

  private_subnet_tags = local.private_subnet_tags

  tags = local.tags
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.16"


  cluster_name                   = var.name
  cluster_version                = var.k8s_version
  cluster_endpoint_public_access = true

  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 10
      desired_size = 4

      instance_types = ["t2.micro"]
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles            = local.aws_k8s_role_mapping



  tags = local.tags
}
