resource "kubernetes_namespace" "shop-for-it" {
  metadata {
    name = "shop-for-it"
  }
}

resource "kubernetes_role" "namespace-viewer" {
  metadata {
    name = "namespace-viewer"
    namespace = "shop-for-it"
  }

  rule {
    api_groups     = [""]
    resources      = ["pods", "services", "secrets", "configmap", "persistentvolumes"]
    verbs          = ["get", "list", "watch", "describe"]
  }

  rule {
    api_groups = ["apps"]
    resources  = ["deployments", "daemonsets", "statefulsets"]
    verbs      = ["get", "list", "watch", "describe"]
  }
}

resource "kubernetes_role_binding" "namespace-viewer" {
  metadata {
    name      = "namespace-viewer"
    namespace = "shop-for-it"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Role"
    name      = "namespace-viewer"
  }
  subject {
    kind      = "User"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "kubernetes_cluster_role" "cluster_viewer" {
  metadata {
    name = "cluster-viewer"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["get", "list", "watch", "describe"]
  }
}


resource "kubernetes_cluster_role_binding" "cluster_viewer" {
  metadata {
    name = "cluster-viewer"
  }

  role_ref {
    kind     = "ClusterRole"
    name     = "cluster-viewer"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "User"
    name      = "admin"
    api_group = "rbac.authorization.k8s.io"
  }
}
