terraform {
  # required_version = "~> 1.1.4"
  backend "remote" {
    organization = "demo-land"
    workspaces {
      name = "aws-demo-app"
    }
  }
}
