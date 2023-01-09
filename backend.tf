# Terraform backend configuration
terraform {
  backend "s3" {
    bucket         = "terraform-state-insighture-new-project"
    key            = "eks-blueprints/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-state-lock"
    encrypt        = true
  }
}