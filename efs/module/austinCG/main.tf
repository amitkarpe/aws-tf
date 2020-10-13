provider "aws" {
	region = "ap-southeast-1"
}

module "efs-0" {
  source        = "AustinCloudGuru/efs/aws"
  version       = "0.2.2"
  vpc_id        = "vpc-058be16ebd7dd4e86"
  efs_name      = "efsqa_cg"
  subnet_ids    = ["subnet-042f1481e760b9893", "subnet-04b34f93989c4c9b9"]
  tags          = {
		    Name	= "efsqa_cg"
		    developer   = "amit"
                  } 
}

