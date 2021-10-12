terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jigsaw-ecstest"
    workspaces {
      name = "tf-ecs-fargate"
    }
  }
}
