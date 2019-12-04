# Expense Tracker

## Description

Conglomerates personal finance transactions from various sources and groups by category. Helps determine trends in spending between different months and identify possible avenues for saving money.

Probably does the same thing as the hundreds of apps like this online, but I can personalize the functionality for me as I see fit. Also, I am in control of my own bank account information, which gives me motivation to tighten the security of this application.

## Environment Setup

The development environment is best completed in the Ubuntu subsystem. However, the majority of local infrastructure configuration will be done only to the ansible command host, so after that is finished, you can probably skip local environment setup, since the command host should be used to push infrastructure changes. To set up your environment for development, the following must be setup:
1. Your SSH public key must be added to the trusted keys for the Expense_Tracker repository. 
    1. Generate with `ssh-keygen -b 4096` 
    2. Add your public key (~/.ssh/id_rsa.pub) to the trusted keys
    3. Clone this repository
1. The following packages must be installed and added to the PATH: 
    1. ansible (`sudo apt install python ansible`) 
    2. terraform (see here: https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu) 
    3. awscli with your user setup to the correct account (see here: https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)
        1. Also, configure with access keys: `aws configure`  
    4. Terragrunt install
        1. `wget -q -O /bin/terragrunt "https://github.com/gruntwork-io/terragrunt/releases/download/v0.20.5/terragrunt_linux_amd64"`
        2. `chmod +x /bin/terragrunt`
1. Setup your local SSH to proxy connections to end hosts through the bastion host (cd-push-host)
    1. 
