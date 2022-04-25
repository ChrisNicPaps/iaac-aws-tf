locals {
  aws_region  = "ca-central-1"
  domain_name = "staging.k8s.wcd.com"
  tags = {
    ops_env              = "staging"
    ops_managed_by       = "terraform",
    ops_source_repo      = "iaac-aws-tf",
    ops_source_repo_path = "terraform-environments/aws/staging/route53",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "wcd-k8-ops"

    workspaces {
      name = "k8-ops-staging-route53"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "github.com/ManagedKube/kubernetes-ops//terraform-modules/aws/route53/hosted-zone?ref=v1.0.30"

  domain_name = local.domain_name
  tags        = local.tags
}
