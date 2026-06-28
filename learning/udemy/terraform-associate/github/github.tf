provider "github" {
  token = var.github_token
}

resource "github_repository" "production-repo" {
  name        = "prod-repo"
  description = "terraform created example repo"
  private     = true
}

resource "github_repository" "production-repo-2" {
  name        = "prod-rep-2"
  description = "terraform created example repo"
  private     = true
}
