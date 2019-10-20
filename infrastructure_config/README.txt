** A Note on certain Terraform Infrastructure **

There is a bit of a catch-22 with infrastructure needed for terraform. Terraform allows you to use infrastructure as code, but for Terraform backend to be set up, you need some infrastructure to facilitate its usage. Since Terraform has not been set up, we cannot configure this prerequisite infrastructure with Terraform of course. As a result, some infrastructure has been manually configured; if setting up new environment, this infrastructure must be manually configured and provisioned. These are as follows:
    (a) A dynamo DB locking table
    (b) S3 bucketfor state file storage