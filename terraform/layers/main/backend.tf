terraform {
  backend "s3" {
    profile        = "padok_dojo"
    dynamodb_table = "devoxx-github-action-oidc-lock"
    bucket         = "devoxx-github-action-oidc"
    key            = "poc"
    region         = "eu-west-3"
  }
}
