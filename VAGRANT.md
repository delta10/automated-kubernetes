# Using Vagrant
It is possible to run a local cluster for testing purposes using [Vagrant](https://www.vagrantup.com).

## Running
A simple

```bash
vagrant up
```

will create a two node cluster and automatically provision the VM's using the sample inventory. If you would like to re-run the playbooks from the host use:

```bash
ANSIBLE_HOST_KEY_CHECKING=false ANSIBLE_SSH_ARGS='-o UserKnownHostsFile=/dev/null -o IdentitiesOnly=yes -o ControlMaster=auto -o ControlPersist=60s' ansible-playbook --limit="all" --inventory-file=.vagrant/provisioners/ansible/inventory --become ansible/install.yml
```
