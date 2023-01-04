provider "kubernetes" {
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = module.eks_blueprints.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = module.eks_blueprints.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_blueprints.eks_cluster_certificate_authority_data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

module "eks_blueprints" {
  source = "github.com/aws-ia/terraform-aws-eks-blueprints?ref=v4.20.0"

  cluster_name = local.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_t3 = {
      node_group_name = local.node_group_name
      instance_types  = ["t3.micro"]
      subnet_ids      = module.vpc.private_subnets

      # Scaling Config
      desired_size = 1
      max_size     = 3
      min_size     = 1
    }
  }

  # List of Additional roles in the cluster
  # map_roles = [
  #   {
  #     rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/TeamRole"
  #     username = "ops-role"
  #     groups   = ["system:masters"]
  #   }
  # ]

  # List of Additional users in the cluster
  # platform_teams = {
  #   admin = {
  #     users = [
  #       data.aws_caller_identity.current.arn
  #     ]
  #   }
  # }

  # List of Additional users in the cluster
  # application_teams = {
  #   team-ksp = {

  #     #   "labels" = {
  #     #     "appName"     = "ksp-team-app",
  #     #     "projectName" = "project-ksp",
  #     #     "environment" = "prod",
  #     #   }

  #     #   "quota" = {
  #     #     "requests.cpu"    = "10000m",
  #     #     "requests.memory" = "20Gi",
  #     #     "limits.cpu"      = "20000m",
  #     #     "limits.memory"   = "50Gi",
  #     #     "pods"            = "15",
  #     #     "secrets"         = "10",
  #     #     "services"        = "10"
  #     #   }

  #     #   # Manifests that can be automatically applied in the team-riker namespace.
  #     #   manifests_dir = "./kubernetes/team-ksp"

  #     users = [data.aws_caller_identity.current.arn]
  #   }
  # }

}
