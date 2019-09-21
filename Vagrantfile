# -*- mode: ruby -*-
# vi: set ft=ruby :

# if $inventory is not set use sample inventory
$inventory = "ansible/inventory/sample" if ! $inventory
$inventory = File.absolute_path($inventory, File.dirname(__FILE__))

# if $inventory has a hosts.ini file use it, otherwise copy over
# vars etc to where vagrant expects dynamic inventory to be
if ! File.exist?(File.join(File.dirname($inventory), "hosts.ini"))
  $vagrant_ansible = File.join(File.dirname(__FILE__), ".vagrant", "provisioners", "ansible")
  FileUtils.mkdir_p($vagrant_ansible) if ! File.exist?($vagrant_ansible)
  if ! File.exist?(File.join($vagrant_ansible,"inventory"))
    FileUtils.ln_s($inventory, File.join($vagrant_ansible,"inventory"))
  end
end

Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu1804"

  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.define "k8s-master1" do |master|
    master.vm.hostname = "k8s-master1"
    master.vm.network :private_network, ip: "172.17.8.10"
  end

  config.vm.define "k8s-node1" do |node1|
    node1.vm.hostname = "k8s-node1"
    node1.vm.network :private_network, ip: "172.17.8.11"
  end

  config.vm.define "k8s-node2" do |node2|
    node2.vm.hostname = "k8s-node2"
    node2.vm.network :private_network, ip: "172.17.8.12"

    # This is placed within the last VM because we only want to run this once
    node2.vm.provision "ansible" do |ansible|
      ansible.playbook = "ansible/install.yml"
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
