terraform {
  backend "remote" {
    organization = "demo-land"

    workspaces {
      name = "aws-echo-sys"
    }
  }
}
