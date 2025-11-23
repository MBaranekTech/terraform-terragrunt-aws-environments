remote_state {
  backend = "s3"
  config = {
    bucket         = "my-tf-state-bucket-martin-001"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "us-west-2"
}
EOF
}