# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

#Lets start the first node
	config.vm.define "tempserver2" do |node1|
		node1.vm.box = "ubuntu/xenial64"
		node1.vm.hostname = 'tempserver2'
		node1.vm.box_url = "ubuntu/xenial64"
#		node1.omnibus.chef_version = "12.10.24"  # Cant use :latest cause https://github.com/chef/chef/issues/4948 bug.
		node1.vm.network "forwarded_port", guest: 80, host: 1234
		node1.vm.network "private_network", ip: "192.168.10.10"
		#Using Chef Solo to avoid using my testing organization
		node1.vm.provision "ansible" do |ansible|
			ansible.verbose= "v"
			ansible.sudo = true
			ansible.playbook = "main.yml"
		end
		config.vm.provider "virtualbox" do |v|
			v.memory = 1024
        		v.cpus = 1
		end
  
	end

end
