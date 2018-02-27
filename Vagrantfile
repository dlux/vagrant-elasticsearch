# -*- mode: ruby -*-
# vi: set ft=ruby :

# Elasticsearch cluster should have a minimum of 3 master-eligible nodes
# Provision them via vagrant multi-machine configuration.
# More multi-machine info see https://www.vagrantup.com/docs/multi-machine/

Vagrant.require_version ">=1.8.4"

################## Common features ###########################################
## Install proxy plugin
proxy_ = false
if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil and ENV['no_proxy'] != nil
  proxy_ = true
  if not Vagrant.has_plugin?('vagrant-proxyconf')
      system 'vagrant plugin install vagrant-proxyconf'
      raise 'vagrant-proxyconf installed - RE-RUN COMMAND.'
  end
end

conf = {
  #'deployment-mode' => 'all-in-one',
  'deployment-mode'  => 'multi-node',
  #'deployment-mode' => 'containers',
  'box'              => 'centos/7',
  'net_oct'          => '192.168.150.',
  'check_update'     => 'False',
  'devtools_path'    => 'https://raw.githubusercontent.com/dlux/InstallScripts/master/install_devtools.sh'
}

## Function runs on every vagrant command.
## keys are only created when folder'.keys' does not exist
def create_keys( numberK )
    nm = numberK + 1
    dir_name = File.join(Dir.pwd, '.keys')
    # Return if folder exist (avoid overriding the keys)
    return unless ! File.exist?(dir_name)

    # Create the keys
    FileUtils.mkdir(dir_name)
    puts "Create keys for all the vms, sets authorized_keys"
    (1..nm).each do |i|
        puts "Creating key #{i}"
        %x[ssh-keygen -q -t rsa -b 4096 -C 'Dlux elastic keypair' -N '' -f #{dir_name}/id_rsa#{i}]
        %x[cat #{dir_name}/id_rsa#{i}.pub >> #{dir_name}/authorized_keys]
    end
end

################## VM main definitions #######################################
Vagrant.configure("2") do |config|

  # Set common configuration
  config.vm.box = conf['box']
  config.vm.box_check_update = conf['check_update']
  config.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
  end

  # Set proxy on VMs
  if proxy_
    config.proxy.http     = ENV['http_proxy']
    config.proxy.https    = ENV['https_proxy']
    config.proxy.no_proxy = ENV['no_proxy']
  end

  case conf['deployment-mode']
    when 'all-in-one'
      config.vm.define 'all-in-one' do |aio|
        aio.vm.hostname = 'all-in-one'
        aio.vm.network 'private_network', ip: conf['net_oct'] + '2', netmask: "255.255.255.240", auto_config: true
        aio.vm.synced_folder './shared_aio', '/opt/shared', create: true, type: 'nfs'
        aio.vm.synced_folder ".", '/vagrant', type: 'nfs'
        aio.vm.provision 'shell', path: conf['devtools_path'], args: '--ansible'
      end

    when 'multi-node'
      machines = 3
      create_keys(machines)
      $cpidrsa = <<SCRIPT
        # !/bin/bash
        cat /vagrant/.keys/authorized_keys >> .ssh/authorized_keys
        cp /vagrant/.keys/$1 .ssh/id_rsa
        chown $2:$2 .ssh/id_rsa
SCRIPT

      config.vm.define "infra" do |node|
        node.vm.hostname = 'infra'
        node.vm.box = 'ubuntu/Xenial64'
        nm = machines + 1
        node.vm.network 'private_network', ip: conf['net_oct'] + '3'
        node.vm.synced_folder './shared_infra', '/opt/shared', create: true
        node.vm.provision 'shell', path: conf['devtools_path'], args: '--ansible'
        node.vm.provision 'shell', inline: $cpidrsa, args: "id_rsa#{nm} ubuntu"
      end

      (1..machines).each do |i|
        config.vm.define "master-#{i}" do |node|
          node.vm.hostname = "master-#{i}"
          i4ip = i + 3
          node.vm.network 'private_network', ip: conf['net_oct'] + "#{i4ip}"
          node.vm.synced_folder "./shared_#{i}", '/opt/shared', create: true, type: 'nfs'
          node.vm.synced_folder ".", '/vagrant', type: 'nfs'
          node.vm.provision 'shell', path: conf['devtools_path']
          node.vm.provision 'shell', inline: $cpidrsa, args: "id_rsa#{i} vagrant"
        end
      end
  end
end
