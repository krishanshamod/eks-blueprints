locals {

  name            = "eks-blueprints-project"
  region          = data.aws_region.current.name
  cluster_version = "1.23"

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  node_group_name = "managed-ondemand"

  # ArgoCD addons applications 
  addon_application = {
    path               = "chart"
    repo_url           = "https://github.com/krishanshamod/eks-blueprints-add-ons.git"
    add_on_application = true
  }

  # ArgoCD workload application
  workload_application = {
    path               = "envs/dev"
    repo_url           = "https://github.com/krishanshamod/eks-blueprints-workloads.git"
    add_on_application = false
  }
}
