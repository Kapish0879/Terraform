provider "aws" {
    region = "us-east-1"
    profile = "kapish"
  
}

terraform {
  backend "s3" {
    bucket = "kapish-tf-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
    profile = "kapish"
    use_local_state = true
    shared_credentials_files = ["/root/.aws/credentials"]
  }
}