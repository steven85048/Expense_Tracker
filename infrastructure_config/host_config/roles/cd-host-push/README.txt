This role sets up the central ansible host that pushes changes to all other slave hosts; setting up ansible on Windows seemed a bit annoying, so I opted to run this host role locally (after git cloning and installing ansible). Ideally, however, it should be run from another host to prevent configuration drift on this host. 

To run locally, can run the following command:
`ansible-playbook --connection=local --inventory 127.0.0.1, playbook.yml`
Alternatives can be found here: https://gist.github.com/alces/caa3e7e5f46f9595f715f0f55eef65c1