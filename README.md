# Expense Tracker

## Description

Conglomerates personal finance transactions from various sources and groups by category. Helps determine trends in spending between different months and identify possible avenues for saving money.

Probably does the same thing as the hundreds of apps like this online, but I can personalize the functionality for me as I see fit. Also, I am in control of my own bank account information, which gives me motivation to tighten the security of this application.

## Environment Setup

The development environment is best completed in the Ubuntu subsystem. However, the majority of local infrastructure configuration will be done only to the ansible command host, so after that is finished, you can probably skip local environment setup, since the command host should be used to push infrastructure changes. To set up your environment for development, the following must be setup:
a. Your SSH public key must be added to the trusted keys for the Expense_Tracker repository.
    - Generate with `ssh-keygen -b 4096`
    - Add your public key (~/.ssh/id_rsa.pub) to the trusted keys
    - Clone this repository
b. The following packages must be installed and added to the PATH:
    - ansible (`sudo apt install python ansible`)
    - terraform (see here: https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu)
    - awscli with your user setup to the correct account (see here: https://docs.aws.amazon.com/polly/latest/dg/setup-aws-cli.html)
        - Also, configure with access keys: `aws configure`        