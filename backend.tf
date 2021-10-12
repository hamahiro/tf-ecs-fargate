terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "test-company"
    workspaces {
      name = "tf-ecs-fargate"
    }
  }
}
