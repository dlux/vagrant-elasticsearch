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
  # Set proxy
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
  config.vm.box = 'centos/7'
  config.vm.box_check_update = false

  # Create and configure ELKS infra nodes
  case conf['deployment-mode']
    when 'all-in-one'
      config.vm.define 'aio' do |aio|
        aio.vm.hostname = 'elks-aio'
        aio.vm.provision 'shell', path: 'elks-aio.sh'
        aio.vm.provider 'virtualbox' do |vb|
            vb.customize ['modifyvm', :id, '--cpus', 2 ]
            vb.customize ['modifyvm', :id, '--memory', 1024 * 3 ]
            vb.customize ["modifyvm", :id, "--natnet1", "192.168.150.0/27"]
        end
        aio.vm.network :forwarded_port, guest: 9200, host: 9200
        aio.vm.network :forwarded_port, guest: 5601, host: 5601
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

  # Create SUT - the system to monitor - after elks is installed
  config.vm.define 'sut' do |sut|
      sut.vm.hostname = 'sut'
      sut.vm.network :forwarded_port, guest: 80, host: 8080
      sut.vm.provision 'shell', path: 'beats.sh'
      sut.vm.provider 'virtualbox' do |vb|
          vb.customize ['modifyvm', :id, '--cpus', 1 ]
          vb.customize ['modifyvm', :id, '--memory', 1024 * 1 ]
          vb.customize ["modifyvm", :id, "--natnet1", "192.168.150.0/27"]
      end
  end
end
