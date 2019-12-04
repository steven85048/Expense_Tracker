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
    1. Get or create private keys (expense-tracker-id_rsa, cd-host-push-id_rsa, expense-tracker-github-id_rsa), and tell admin to add these keys to authorized_keys if necessary
    2. Add these keys to your ssh-agent:
        1. `` eval `ssh-agent` ``
        2. `ssh-add ~/.ssh/<private-key>`
        3. Validate added keys: `ssh-add -l`
1. To validate your connection through the bastion host:
    1. Consider that you are connecting to the host at: ubuntu@172.31.33.115 (private-IP)
        1. `cd /Expense_Tracker/infrastructure_config/host_config_ansible`
        2. `ssh -F ./ssh.cfg ubuntu@172.31.33.115`
        3. If you have successfully connected, congratulations!
1. Ansible setup:
    1. If on windows (working through WSL), `export ANSIBLE_CONFIG=./ssh.cfg`
