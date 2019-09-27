# This file provides provenance of the infrastructure operations ran for future use

- Updating the bucket policy to disallow for unencrypted writes and other operations:
    1. cd bucket_config/<project>/
    2. `aws s3api put-bucket-policy --bucket $(aws s3api list-buckets --query "Buckets[].Name" --output text) --policy file://deny-unencrypted.json`

a. Use $( - ) to wrap sub shell commands within a larger one
b. must specify file:// in order for aws to know whether a file is being used or text

- Copying a file from computer to s3 bucket
    1. cd to folder with file
    2. `aws s3 cp <local-file> s3://$(aws s3api list-buckets --query "Buckets[].Name" --output text)/<bucket-dir>/<s3-file-name> --sse `
