# Automated Kubernetes

- Kubernetes (1.18.6)
- Docker (19.03.8)
- Weave or Flannel network layer

This repository contains [Terraform](https://www.terraform.io/) and [Ansible](https://www.ansible.com/) configuration that can be used to deploy a single and multi-master (HA) Kubernetes cluster. The Terraform scripts are specific to AWS, the Ansible scripts can be run on any configured Ansible environment.

## Prepairing the deployment

Configure your local environment by changing `inventory/local/hosts.ini` to match your setup. Also change `k8s_apiserver_advertise_address` or `k8s_control_plane_endpoint` to the internal IP address of the Kubernetes master or load balancer.

## Provisioning the cluster

Provision the cluster with Ansible by using:

```bash
cd ansible/
ansible-playbook install.yml
```

## Conformance testing

You can validate the cluster using [Sonobuoy](https://github.com/heptio/sonobuoy/) and [kube-bench](https://github.com/aquasecurity/kube-bench):

```bash
ansible-playbook validate.yml
```

## Upgrading and downgrading the cluster

To upgrade or downgrade the cluster run:

```bash
ansible-playbook upgrade.yml --extra-vars '{"k8s_version": "1.18.6"}'
```

When upgrading to newer versions always follow the [Kubernetes version skew policy](https://kubernetes.io/docs/setup/release/version-skew-policy/).

## Destroying the cluster

Destroying the cluster can be done using:

```bash
ansible-playbook destroy.yml
```

## Contributing

Contributions are welcome, see [CONTRIBUTING.md](CONTRIBUTING.md) for more details. By contributing to this project, you accept and agree the the terms and conditions as specified in the [Contributor Licence Agreement](CLA.md).

## Licence

The software is distributed under the EUPLv1.2 licence, see the [LICENCE](LICENCE) file.
