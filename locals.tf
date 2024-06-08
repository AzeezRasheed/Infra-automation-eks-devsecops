locals {
  public_subnet_tags  = { "kubernetes.io/role/elb" = 1 }
  private_subnet_tags = { "kubernetes.io/role/internal-elb" = 1 }
  tags                = { App = "shop-for-it-eks-devsecops" }
  aws_k8s_role_mapping = [{
    rolearn  = aws_iam_role.external-admin.arn
    username = "admin"
    groups   = ["none"]
    },
    {
      rolearn  = aws_iam_role.external-developer.arn
      username = "developer"
      groups   = ["none"]
    }
  ]
}
