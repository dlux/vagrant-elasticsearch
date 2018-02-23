# -*- mode: ruby -*-
# vi: set ft=ruby :

# Elasticsearch cluster should have a minimum of 3 master-eligible nodes
# Provision them via vagrant multi-machine configuration.
# More multi-machine info see https://www.vagrantup.com/docs/multi-machine/

Vagrant.configure("2") do |config|
  common = {
    'box'          => 'centos/7',
    'net_oct'      => '192.168.150.',
    'check_update' => 'False'
  }

  (1..3).each do |i|
    config.vm.define "master-#{i}" do |node|
      node.vm.box = common['box']
      node.vm.box_check_update = common['check_update']
      node.vm.network "private_network", ip: common['net_oct'] + '10' + "#{i}"
      node.vm.synced_folder "./shared_#{i}" '/opt/shared', create: true
      node.vm.provider "virtualbox" do |vb|
        #vb.memory = "1024"
        vb.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
      end
      node.vm.provision 'shell' do |s|
        s.path = 'https://raw.githubusercontent.com/dlux/InstallScripts/master/install_devtools.sh'
      end
    end
  end
end
