# -*- mode: ruby -*-
# vi: set ft=ruby :

# Elasticsearch cluster should have a minimum of 3 master-eligible nodes
# Provision them via vagrant multi-machine configuration.
# More multi-machine info see https://www.vagrantup.com/docs/multi-machine/

Vagrant.require_version ">=1.8.4"

# Install vagrant proxy plugin if needed
if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil and ENV['no_proxy'] != nil
  if not Vagrant.has_plugin?('vagrant-proxyconf')
      system 'vagrant plugin install vagrant-proxyconf'
      raise 'vagrant-proxyconf was installed but it requires to execute again'
  end
end

# Provision the VMs
Vagrant.configure("2") do |config|
  common = {
    'box'          => 'centos/7',
    'net_oct'      => '192.168.150.',
    'check_update' => 'False'
  }

  (1..3).each do |i|
    config.vm.define "master-#{i}" do |node|
      node.vm.box = common['box']
      node.vm.hostname = "master-#{i}"
      node.vm.box_check_update = common['check_update']
      node.vm.network "private_network", ip: common['net_oct'] + '10' + "#{i}"
      node.vm.synced_folder "./shared_#{i}", '/opt/shared', create: true, type: "nfs"
      node.vm.provider "virtualbox" do |vb|
        vb.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
      end

      # Set proxy on VMs
      if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil and ENV['no_proxy'] != nil
        node.proxy.http     = ENV['http_proxy']
        node.proxy.https    = ENV['https_proxy']
        node.proxy.no_proxy = ENV['no_proxy']
      end
      node.vm.provision 'shell' do |s|
        s.path = 'https://raw.githubusercontent.com/dlux/InstallScripts/master/install_devtools.sh'
      end
    end
  end
end
