terraform {
  backend "s3" {
    bucket         = "lili-terraform-state"
    key            = "terraform/state/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state"
    encrypt        = true
  }
}
