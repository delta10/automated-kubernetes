# Automated Kubernetes
- Kubernetes (1.15.3)
- Calico (3.8)
- Docker (18.06.2-ce)

This repository contains [Terraform](https://www.terraform.io/) and [Ansible](https://www.ansible.com/) configuration that can be used to deploy a single and multi-master (HA) Kubernetes cluster. The Terraform scripts are specific to AWS, the Ansible scripts can be run on any configured Ansible environment.

## Prepairing the deployment
Configure your local environment by changing `inventory/local/hosts.ini` to match your setup.

## Provisioning the cluster
Provision the cluster with Ansible by using:

```bash
cd ansible/
ansible-playbook install.yml
```

## Validating the cluster
Validating the cluster using the [Sonobuoy](https://github.com/heptio/sonobuoy/) and [kube-bench](https://github.com/aquasecurity/kube-bench):

```bash
ansible-playbook validate.yml
```

## Upgrading the cluster
To upgrade the cluster run:

```bash
ansible-playbook upgrade.yml --extra-vars '{"k8s_version": "1.15.1"}'
```

## Destroying the cluster
Destroying the cluster can be done using:

```bash
ansible-playbook destroy.yml
```
