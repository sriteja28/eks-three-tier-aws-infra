########################################
# Provider to connect to AWS
# https://www.terraform.io/docs/providers/aws/
########################################
terraform {
  required_version = ">= 1.0"
  backend "s3" {} # use backend.config for remote backend
}

provider "aws" {
  region = var.region
  # profile = var.profile_name

  assume_role {
    role_arn = "arn:aws:iam::${var.account_id}:role/${var.role_name}"
  }
}

# In case of not creating the cluster, this will be an incompletely configured, unused provider, which poses no problem.
# ref: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/v12.1.0/README.md#conditional-creation, https://github.com/terraform-aws-modules/terraform-aws-eks/issues/911
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  #config_path           = "./kubeconfig_eks-ue1-dev-terraform-eks-dev-infra"
}