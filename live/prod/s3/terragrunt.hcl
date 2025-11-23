include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../modules/s3"
}

inputs = {
  bucket_name = "my-prod-bucket-martin-001"
  environment = "prod"
}