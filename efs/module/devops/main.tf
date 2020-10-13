module "efs" {
  source        = "devops-workflow/efs/aws"
  version       = "0.4.0"


  name            = "efsci_TF"
  environment     = "testing"
  zone_id         = "Z2B1HOCOP8U1QI"
  security_groups = ["sg-094d4519edd873a30"]
  ingress_cidr    = ["0.0.0.0/0"]
  subnets         = ["subnet-042f1481e760b9893", "subnet-0fb7d163171d3ab9a"]
  vpc_id          = "vpc-058be16ebd7dd4e86"
}
