terraform {
  required_version = ">= 1.3.0"

  backend "s3" {
    bucket         = "threat-comp-tfstate"
    key            = "ecs/terraform.tfstate"
    region         = "eu-west-2"
    dynamodb_table = "threat-comp-tf-locks"
    encrypt        = true
  }
}
