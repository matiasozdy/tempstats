# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure("2") do |config|

#Lets start the instance
	config.vm.define "tempserver2" do |node1|
		node1.vm.box = "ubuntu/xenial64"
		node1.vm.hostname = 'tempserver2'
		node1.vm.box_url = "ubuntu/xenial64"
		node1.vm.network "forwarded_port", guest: 80, host: 1234
		node1.vm.network "private_network", ip: "192.168.10.10"
		#Using ansible to provision
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
