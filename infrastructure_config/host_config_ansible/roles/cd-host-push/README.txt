This role sets up the central ansible host that pushes changes to all other slave hosts; setting up ansible on Windows seemed a bit annoying, so I opted to run this host role locally (after git cloning and installing ansible). Ideally, however, it should be run from another host to prevent configuration drift on this host. 
The configuration is as follows:
    1. Adds Git and Boto (for S3) dependencies
    2. Sets up the provision-central user, which will be used for ansible-push to other hosts
    3. Sets up ssh-agent, and adds the environment configurations to .profile
    4. Clones the Expense_Tracker git repository for provision-central
    5. Adds a .ssh config to allow for ssh agent forwarding of the github private key

To run locally, can run the following command:
`ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml`
Alternatives can be found here: https://gist.github.com/alces/caa3e7e5f46f9595f715f0f55eef65c1