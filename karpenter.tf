# IAM service linked role for spot instances
resource "aws_iam_service_linked_role" "spotInstanceRole" {
  aws_service_name = "spot.amazonaws.com"
}

# Creates Karpenter native node termination handler resources and IAM instance profile
module "karpenter" {
  source  = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = "~> 19.5"

  cluster_name = local.name

  # IRSA will be created by the kubernetes-addons module
  create_irsa = false
}