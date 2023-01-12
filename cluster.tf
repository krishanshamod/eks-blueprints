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
  source = "github.com/krishanshamod/terraform-aws-eks-blueprints"

  cluster_name = local.name

  # EKS Cluster VPC and Subnet mandatory config
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  # EKS CONTROL PLANE VARIABLES
  cluster_version = local.cluster_version

  # EKS MANAGED NODE GROUPS
  managed_node_groups = {
    mg_m5_large = {
      node_group_name = local.node_group_name
      instance_types  = ["m5.large"]
      subnet_ids      = module.vpc.private_subnets

      # Scaling Config
      desired_size = 2
      max_size     = 4
      min_size     = 1
    }
  }

  platform_teams = {
    admin = {
      users = [
        data.aws_caller_identity.current.arn,
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/k8s-admin"
      ]
    }
  }

  application_teams = {
    team-riker = {
      users = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:user/k8s-dev"]
    }
  }

}
