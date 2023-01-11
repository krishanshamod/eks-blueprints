module "kubernetes_addons" {
  source = "github.com/krishanshamod/terraform-aws-eks-blueprints/modules/kubernetes-addons"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # ArgoCD addon
  enable_argocd         = true
  argocd_manage_add_ons = true

  argocd_applications = {
    addons = local.addon_application
    #workloads = local.workload_application 
  }

  # Extra addons
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/

  enable_aws_load_balancer_controller  = true
  enable_karpenter                     = false
  enable_amazon_eks_aws_ebs_csi_driver = true
  enable_aws_for_fluentbit             = true
  enable_metrics_server                = true
  enable_kubecost                      = true
}


