module "kubernetes_addons" {
  source = "github.com/krishanshamod/terraform-aws-eks-blueprints/modules/kubernetes-addons"

  eks_cluster_id = module.eks_blueprints.eks_cluster_id

  # ArgoCD addon
  enable_argocd         = true
  argocd_manage_add_ons = true

  argocd_applications = {
    addons    = local.addon_application
    workloads = local.workload_application
  }

  # Extra addons
  # https://aws-ia.github.io/terraform-aws-eks-blueprints/add-ons/

  enable_amazon_eks_aws_ebs_csi_driver = true
  # enable_aws_for_fluentbit             = true
  # enable_metrics_server                = true
  enable_kubecost      = true
  enable_ingress_nginx = true
  enable_cert_manager  = true

  enable_karpenter = true

  karpenter_helm_config = {
    awsInterruptionQueueName  = data.aws_arn.queue.resource
    awsDefaultInstanceProfile = "${local.name}-${local.node_group_name}"
  }

  karpenter_node_iam_instance_profile        = module.karpenter.instance_profile_name
  karpenter_enable_spot_termination_handling = true
  karpenter_sqs_queue_arn                    = module.karpenter.queue_arn
}


