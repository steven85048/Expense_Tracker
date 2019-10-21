** A Note on certain Terraform Infrastructure **

There is a bit of a catch-22 with infrastructure needed for terraform. Terraform allows you to use infrastructure as code, but for Terraform backend to be set up, you need some infrastructure to facilitate its usage. Since Terraform has not been set up, we cannot configure this prerequisite infrastructure with Terraform of course. As a result, some infrastructure has been manually configured; if setting up new environment, this infrastructure must be manually configured and provisioned. These are as follows:
    1. A dynamo DB locking table
    2. S3 bucketfor state file storage

** A general note on the design on of the Terraform/Ansible host infrastructure **

You may have noticed that there is often a terraform and ansible role of the same name -- the terraform is used for the higher level infrastructure configuration (e.g. provisioning the actual ec2 instance), whereas ansible is used for finer grained infrastructure setup (e.g. installing dependencies, setup groups/users, etc.). The way these two interact is that terraform first provisions the infrastructure, then, through the local-exec, waits until the infrastructure is configured then runs the associated ansible-playbook.

This design was sourced from this article: https://medium.com/faun/building-repeatable-infrastructure-with-terraform-and-ansible-on-aws-3f082cd398ad