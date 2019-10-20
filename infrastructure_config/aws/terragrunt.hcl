remote_state {
    backend = "s3"

    config = {
        encrypt = true
        bucket = "expense-tracker-terraform"
        key = "${path_relative_to_include()}/terraform.tfstate"
        region = "us-east-2"
        #dynamodb_table = "expense-tracker-terraform-locks"
        dynamodb_table = "terraform-state-lock-dynamo"
    }
}

inputs = {
    aws_region = "us-east-2"
    aws_profile = "dev"
}