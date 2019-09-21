variable "region" {
    default = "eu-west-1" # Ireland
}

variable "ami" {
    default = "ami-0ee06eb8d6eebcde0" # Ubuntu 18.04 (Bionic) LTS
}

variable "k8s-master_instance_type" {
    default = "t2.medium"
}

variable "k8s-master_count" {
    default = "1"
}

variable "k8s-node_instance_type" {
    default = "t2.medium"
}

variable "k8s-node_count" {
    default = "2"
}

variable "key_name" {
    default = "management"
}
