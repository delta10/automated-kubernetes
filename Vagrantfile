# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "k8s-master1" do |master|
    master.vm.hostname = "k8s-master1"
    master.vm.network "private_network", ip: "172.21.0.10"
  end

  config.vm.define "k8s-node1" do |node1|
    node1.vm.hostname = "k8s-node1"
    node1.vm.network "private_network", ip: "172.21.0.11"
  end

  config.vm.define "k8s-node2" do |node2|
    node2.vm.hostname = "k8s-node2"
    node2.vm.network "private_network", ip: "172.21.0.12"

    # This is placed within the last VM because we only want to run this once
    node2.vm.provision "ansible" do |ansible|
      ansible.playbook = "playbook.yml"
      ansible.compatibility_mode = "2.0"
      ansible.limit = "all"
      ansible.become = true
      ansible.groups = {
        "k8s_master" => ["k8s-master1"],
        "k8s_node" => ["k8s-node1", "k8s-node2"]
      }
    end
  end
end
