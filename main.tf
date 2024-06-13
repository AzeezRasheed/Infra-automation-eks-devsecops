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
    coredns = {
      enabled     = true
      most_recent = true
      configuration_values = jsonencode({
        computeType = "Fargate"
        # Ensure that we fully utilize the minimum amount of resources that are supplied by
        # Fargate https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
        # Fargate adds 256 MB to each pod's memory reservation for the required Kubernetes
        # components (kubelet, kube-proxy, and containerd). Fargate rounds up to the following
        # compute configuration that most closely matches the sum of vCPU and memory requests in
        # order to ensure pods always have the resources that they need to run.
        resources = {
          limits = {
            cpu = "0.5"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "1Gi"
          }
          requests = {
            cpu = "0.25"
            # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
            # request/limit to ensure we can fit within that task
            memory = "512Mi"
          }
        }
    }) }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }


  fargate_profiles = {
    # eks_cluster_name = "shop-for-it-eks"
    fargate-compute-type = {
      selectors = [
        {
          namespace = "default"
          labels = {
            app = "demo-app-shop-for-it-frontend"
          }
        },
        {
          namespace = "default"
          labels = {
            app = "demo-app-shop-for-it-backend"
          }
        },
        { namespace = "*", labels = { compute-type = "fargate" } }
      ]
    }
    fargate-core-dns = {
      selectors = [
        { namespace = "kube-system", labels = { "k8s-app" = "kube-dns" } }
      ]
    }
  }

  vpc_id                    = module.vpc.vpc_id
  subnet_ids                = module.vpc.private_subnets
  cluster_enabled_log_types = var.kubernetes_cluster_enabled_log_types

  eks_managed_node_groups = {
    example = {
      min_size     = 2
      max_size     = 10
      desired_size = 4

      instance_types = ["t3.micro"]
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles            = local.aws_k8s_role_mapping



  tags = local.tags
}


# resource "aws_eks_fargate_profile" "shop-for-it-fg" {
#   cluster_name           = module.eks.cluster_name
#   fargate_profile_name   = "shop-for-it-fg"
#   pod_execution_role_arn = aws_iam_role.eks-fargate-profile.arn

#   # These subnets must have the following resource tag: 
#   # kubernetes.io/cluster/<CLUSTER_NAME>.
#   subnet_ids = module.vpc.private_subnets


#   selector {
#     namespace = "default"
#   }
# }

