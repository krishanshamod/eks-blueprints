# Find the user currently in use by AWS
data "aws_caller_identity" "current" {}

# Region in which to deploy the solution
data "aws_region" "current" {}

# Availability zones to use in our solution
data "aws_availability_zones" "available" {
  state = "available"
}

# Get the EKS cluster data
data "aws_eks_cluster" "cluster" {
  name = module.eks_blueprints.eks_cluster_id
}

# Get the EKS cluster auth data
data "aws_eks_cluster_auth" "this" {
  name = module.eks_blueprints.eks_cluster_id
}

# Get the Karpenter queue ARN
data "aws_arn" "queue" {
  arn = module.karpenter.queue_arn
}