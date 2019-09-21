provider "aws" {
    region = "${var.region}"
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_security_group" "k8s-master" {
    name = "k8s-master"
    description = "The ports required to run a Kubernetes master."

    # Kubernetes API server
    ingress {
        from_port = 6443
        to_port = 6443
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }

    # etcd server client API
    ingress {
        from_port = 2379
        to_port = 2380
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }

    # Kubelet API, kube-scheduler, kube-controller-manager, Read-Only Kubelet API
    ingress {
        from_port = 10250
        to_port = 10255
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }
}

resource "aws_security_group" "k8s-node" {
    name = "k8s-node"
    description = "The ports required to run a Kubernetes node."

    # Kubelet API
    ingress {
        from_port = 10250
        to_port = 10250
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }

    # Read-only Kubelet API
    ingress {
        from_port = 10255
        to_port = 10255
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }

    # NodePort services
    ingress {
        from_port = 30000
        to_port = 32767
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }
}

resource "aws_instance" "k8s-master" {
    instance_type = "${var.k8s-master_instance_type}"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    security_groups = ["default", "k8s-master"]

    count = "${var.k8s-master_count}"

    tags = {
        Name = "k8s-master-${count.index}"
    }
}

resource "aws_instance" "k8s-node" {
    instance_type = "${var.k8s-node_instance_type}"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    security_groups = ["default", "k8s-node"]

    count = "${var.k8s-node_count}"

    tags = {
        Name = "k8s-node-${count.index}"
    }
}
