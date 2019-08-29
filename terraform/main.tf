provider "aws" {
    region = "${var.region}"
}

data "aws_security_group" "default" {
  name = "default"
}

resource "aws_security_group" "salt-master" {
    name = "salt-master"
    description = "The ports required to run a Salt master."

    ingress {
        from_port = 4505
        to_port = 4506
        protocol = "tcp"
        security_groups = [ "${data.aws_security_group.default.id}" ]
    }

    tags {
        Name = "salt-master"
    }
}

resource "aws_security_group" "kube-master" {
    name = "kube-master"
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

    tags {
        Name = "kube-master"
    }
}

resource "aws_security_group" "kube-node" {
    name = "kube-node"
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

    tags {
        Name = "kube-node"
    }
}

resource "aws_instance" "salt-master" {
    instance_type = "${var.salt-master_instance_type}"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    security_groups = [ "default", "salt-master"]

    tags {
        Name = "salt-master"
    }

    connection {
        user = "${var.provisioner_user}"
    }
}

resource "aws_instance" "kube-master" {
    instance_type = "${var.kube-master_instance_type}"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    security_groups = ["default", "kube-master"]

    count = "${var.kube-master_count}"

    tags {
        Name = "kube-master-${count.index}"
    }

    connection {
        user = "${var.provisioner_user}"
    }
}

resource "aws_instance" "kube-node" {
    instance_type = "${var.kube-node_instance_type}"
    ami = "${var.ami}"
    key_name = "${var.key_name}"
    security_groups = ["default", "kube-node"]

    count = "${var.kube-node_count}"

    tags {
        Name = "kube-node-${count.index}"
    }

    connection {
        user = "${var.provisioner_user}"
    }
}
