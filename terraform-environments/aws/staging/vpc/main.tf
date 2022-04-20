locals {
  aws_region       = "ca-central-1"
  environment_name = "staging"
  tags = {
    ops_env              = "${local.environment_name}"
    ops_managed_by       = "terraform",
    ops_source_repo      = "iaac-aws-tf",
    ops_source_repo_path = "terraform-environments/aws/${local.environment_name}/vpc",
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
      name = "k8-ops-staging-vpc"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# VPC
#
module "vpc" {
  #source = "https://github.com/usmanlakhani/iaac-aws-tf/tree/VPC/terraform-modules/aws/vpc?ref=v3.2.0"
  source = "./terraform-modules/aws/vpc"
  aws_region       = local.aws_region
  azs              = ["ca-central-1a", "ca-central-1b", "uca-central-1d"]
  vpc_cidr         = "10.0.0.0/16"
  private_subnets  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets   = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
  environment_name = local.environment_name
  cluster_name     = local.environment_name
  tags             = local.tags
}