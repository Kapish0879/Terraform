provider "aws" {
    region = "us-east-1"
    profile = "kapish"
  
}

terraform {
  backend "s3" {
    bucket = "terraform-practice-cbz"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "kapish"
    use_lockfile = true
    shared_credentials_files = ["/home/ubuntu/.aws/credentials"]
  }
}




