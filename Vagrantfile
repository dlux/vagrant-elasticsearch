# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">=1.8.4"

conf = {
  'deployment-mode' => 'all-in-one',
  #'deployment-mode'  => 'multi-node',
  #'deployment-mode' => 'containers',
}

################## VM main definitions #######################################
Vagrant.configure("2") do |config|
  if ENV['http_proxy'] != nil and ENV['https_proxy'] != nil and ENV['no_proxy'] != nil
      if not Vagrant.has_plugin?('vagrant-proxyconf')
          system 'vagrant plugin install vagrant-proxyconf'
          raise 'vagrant-proxyconf was installed but it requires to execute again'
      end
      config.proxy.http     = ENV['http_proxy']
      config.proxy.https    = ENV['https_proxy']
      config.proxy.no_proxy = ENV['no_proxy']
  end

  # Set common configuration
  config.vm.box = 'bento/centos-7.4'
  config.vm.box_check_update = false

  config.vm.provider 'virtualbox' do |vb|
        vb.customize ['modifyvm', :id, '--cpus', 1 ]
        vb.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
        vb.customize ["modifyvm", :id, "--natnet1", "192.168.150.0/27"]
  end

  # Create SUT - the system to monitor
  config.vm.define 'sut' do |sut|
      sut.vm.hostname = 'sut'
      sut.vm.provision 'shell', path: 'beats.sh', args: ['system']
  end

  # Create and configure ELKS infra nodes
  case conf['deployment-mode']
    when 'all-in-one'
      config.vm.define 'all-in-one' do |aio|
        aio.vm.hostname = 'elks-aio'
        aio.vm.provision 'shell', path: 'elasticsearch.sh'
        aio.vm.provision 'shell', path: 'kibana.sh'
      end

    when 'multinode'
      raise 'elks multinode under construction'
      machines = 3
      (1..machines).each do |i|
        config.vm.define "elks-#{i}" do |node|
          node.vm.hostname = "elks-#{i}"
        end
      end
  end # END DEPLYMENT CASE
end
