module "my_vpc" {

  source = "./modules/vpc"
  vpc_cidr             = "10.0.0.0/16"
  public_subnets_cidr  = ["10.0.3.0/24","10.0.4.0/24"]
  private_subnets_cidr = ["10.0.2.0/24"]
  availability_zones = ["ap-south-1a","ap-south-1b","ap-south-1c"]
}

module "eks" {
  source  = "./modules/eks"
  cluster_name    = "my-cluster"
  subnet_id = concat(module.my_vpc.public_subnets,module.my_vpc.private_subnets)
  depends_on = [module.my_vpc]
  cluster_addons= {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

}