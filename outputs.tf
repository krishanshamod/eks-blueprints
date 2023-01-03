output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "configure_kubectl" {
  description = "Update your kubeconfig"
  value       = module.eks_blueprints.configure_kubectl
}
