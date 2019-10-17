remote_state {
    backend = "s3"

    config = {
        encrypt = true
        bucket = "expense-tracker-terraform"
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "us-east-2"
        dynamodb_table = "terraform-locks"
    }
}

inputs = {
    aws_region = "us-east-2"
    aws_profile = "dev"
    tfstate_global_bucket = "expense-tracker-terraform"
    tfstate_global_bucket_region = "us-east-1"
}