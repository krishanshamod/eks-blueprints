# Cluster role for developers
resource "kubernetes_cluster_role" "developer" {
  metadata {
    name = "developer"
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }

  depends_on = [
    module.eks_blueprints
  ]
}

# Cluster role binding for developers
resource "kubernetes_cluster_role_binding" "developer" {
  metadata {
    name = "developer"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }

  subject {
    kind      = "Group"
    name      = "developer"
    api_group = "rbac.authorization.k8s.io"
  }

  depends_on = [
    kubernetes_cluster_role.developer
  ]
}