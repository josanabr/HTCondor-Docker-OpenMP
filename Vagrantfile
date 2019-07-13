# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "htcondor" do |htcondor|
  	htcondor.vm.box = "ubuntu/xenial64"
  	htcondor.vm.hostname = "htcondor.local"
        htcondor.vm.provision "shell", path: "script.sh"
	htcondor.vm.network "forwarded_port", guest: 22, host: 2223
  	htcondor.vm.provider :virtualbox do |vb|
		vb.customize [ 'modifyvm', :id, '--memory', '2048' ]
		vb.customize [ 'modifyvm', :id, '--cpus', '2' ]
		vb.customize [ 'modifyvm', :id, '--name', 'htcondor+docker' ]
  	end
  end
end
