variable "region" {
    default = "eu-west-1" # Ireland
}

variable "ami" {
    default = "ami-0ee06eb8d6eebcde0" # Ubuntu 18.04 (Bionic) LTS
}

variable "provisioner_user" {
    default = "ubuntu" # The default user to login when provisioning
}

variable "salt-master_instance_type" {
    default = "t2.small"
}

variable "kube-master_instance_type" {
    default = "t2.medium"
}

variable "kube-master_count" {
    default = "1"
}

variable "kube-node_instance_type" {
    default = "t2.medium"
}

variable "kube-node_count" {
    default = "2"
}

variable "key_name" {
    default = "management"
}
