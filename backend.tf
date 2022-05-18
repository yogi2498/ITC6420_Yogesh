terraform {
  backend "s3" {
    bucket = "neu-terra-state-bucket"
    key    = "terraform/cluster.tfstate"
    region = "us-west-2"
  }
}
