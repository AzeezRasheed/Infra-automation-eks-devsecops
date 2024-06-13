# resource "helm_release" "shop-for-it" {
#     namespace        = "default"
#   #   create_namespace = true

#   name       = "shop-for-it-release"
#   repository = "https://azeezrasheed.github.io/shop-for-it-demo-helm-repo/"
#   chart      = "shop-for-it"
#   version    = "0.1.3"

#   timeout = 600
#   #   set {
#   #     name  = "cluster.enabled"
#   #     value = "true"
#   #   }

#   #   set {
#   #     name  = "metrics.enabled"
#   #     value = "true"
#   #   }

#   #     set {
#   #     name  = "region"
#   #     value = var.aws_region
#   #   }

#   #   set {
#   #     name  = "vpcId"
#   #     value = module.vpc.vpc_id
#   #   }
#   depends_on = [module.eks]

# }


# resource "helm_release" "metrics-server" {
#   name = "metrics-server"

#   repository = "https://kubernetes-sigs.github.io/metrics-server/"
#   chart      = "metrics-server"
#   namespace  = "kube-system"
#   version    = "3.8.2"

#   set {
#     name  = "metrics.enabled"
#     value = false
#   }

# #   depends_on = [aws_eks_fargate_profile.shop-for-it-fg]
# }


# resource "helm_release" "aws-load-balancer-controller" {
#   name = "aws-load-balancer-controller"

#   repository = "https://aws.github.io/eks-charts"
#   chart      = "aws-load-balancer-controller"
#   namespace  = "kube-system"
#   version    = "1.4.1"

#   set {
#     name  = "clusterName"
#     value = module.eks.cluster_name
#   }

#   set {
#     name  = "image.tag"
#     value = "v2.4.2"
#   }

#   set {
#     name  = "replicaCount"
#     value = 1
#   }

#   set {
#     name  = "serviceAccount.name"
#     value = "aws-load-balancer-controller"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.aws_load_balancer_controller.arn
#   }

#   # EKS Fargate specific
#   set {
#     name  = "region"
#     value = "us-east-1"
#   }

#   set {
#     name  = "vpcId"
#     value = module.vpc.vpc_id
#   }

# #   depends_on = [aws_eks_fargate_profile.shop-for-it-fg]
# }