# This file provides provenance of the infrastructure operations ran for future use
- Really, it is just a reference sheet for the commands in the future to relearn.

- Updating the bucket policy to disallow for unencrypted writes and other operations:
    1. cd bucket_config/<project>/
    2. `aws s3api put-bucket-policy --bucket $(aws s3api list-buckets --query "Buckets[].Name" --output text) --policy file://deny-unencrypted.json`

a. Use $( - ) to wrap sub shell commands within a larger one
b. must specify file:// in order for aws to know whether a file is being used or text

- Copying a file from computer to s3 bucket
    1. cd to folder with file
    2. `aws s3 cp <local-file> s3://$(aws s3api list-buckets --query "Buckets[].Name" --output text)/<bucket-dir>/<s3-file-name> --sse `

- Get the CIDR block of a VPC given the ID
    1. `aws ec2 describe-vpcs --vpc-ids vpc-a28e66c9 --query "Vpcs[].CidrBlock" --output text`

- Get the route table ID associated with a certain VPC
    1. aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-a28e66c9 --query "RouteTables[].Associations[].RouteTableId" --output text

a. --filter must have Name and Value, where name is the type of filter

- Create a route endpoint associated with a VPC given just the VPC ID
    1. aws ec2 create-vpc-endpoint --vpc-id vpc-a28e66c9 --route-table-ids $(aws ec2 describe-route-tables --filters Name=vpc-id,Values=vpc-a28e66c9 --query "RouteTables[].Associations[].RouteTableId" --output text) --service-name com.amazonaws.us-east-2.s3 --region us-east-2

- Can examine the new bug arrival graph, can form a determination of whether the software is viable for release

Playbook for adding SSH access from host A into host B:
    (reference here: https://www.bogotobogo.com/DevOps/AWS/aws-adding-a-ssh-user-account-on-linux-instance.php)
    1. Create a new linux user on host B, e.g. provision; disable the password
    2. Change users to the new user, and create ~/.ssh/ directory with 0700 access modifier
    3. Create an ~/.ssh/authorized_keys file with 0600 access modifiers
    4. Now under host A under the linux user with access, run `ssh-keygen -t rsa`; this will create a new public/private key in the ~/.ssh directory
    5. Copy the contents of the newly created public key (e.g. ~/.ssh/id_rsa.pub) from host A into the authorized_keys file in host B
        - Note that when copy and pasting, vi must be set to paste mode in order to copy correctly
    6. Host A should be able to ssh into host B under that linux user now

Playbook for creating an ansible control host for an inventory of slave hosts:
    (reference here: https://www.howtoforge.com/tutorial/setup-new-user-and-ssh-key-authentication-using-ansible/)
    1. Provision your slave hosts and your ansible control host; the slave hosts can be made dynamically, but should follow a similar tagging (grouping) system
    2. On the ansible control host, perform the following configuration:
        a. Install ansible and python (apt) 
        b. Setup a new provision user that should perform all the ansible funk
        c. Git clone the repository with the host playbooks
    3. Each slave host should have the following playbook (in addition to all specific configurations) [essentially the ssh config above]:
        a. Create a provision user with a S3 stored password
        b. Add sudo persmissions to that user
        c. Copy the SSH public key from the master host (~/.ssh/id_rsa.pub) into the slave host authorized_keys
        d. Disable password authentication and root login (this forces all changes to go through the master host, and repository by extension)
    4. Run the playbook on the master host with an inventory file specifying the slave hosts to run the playbooks against

Note that SSH automatically uses the ~/.ssh/id_rsa when sshing onto a host; in order to specify what private key that ssh uses, need to configure a .ssh/config (https://stackoverflow.com/questions/2419566/best-way-to-use-multiple-ssh-private-keys-on-one-client)

To kill all ssh-agent processes (or all that have ssh-agent in the name) under user provision-central:
    `pgrep -f "ssh-agent" -u "provision-central" | while read line ; do kill -9 $line ; done`