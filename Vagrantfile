# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.define "centos" do |centos|
    centos.vm.box = "centos65"
    centos.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_centos-6.5_chef-provisionerless.box"
    centos.omnibus.chef_version = :latest
    centos.vm.network :private_network, ip: "192.168.254.10"
  end

  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu-1204"
    ubuntu.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_ubuntu-12.04_chef-provisionerless.box"
    ubuntu.omnibus.chef_version = :latest
    ubuntu.vm.network :private_network, ip: "192.168.254.12"
  end


  config.vm.boot_timeout = 120
  config.berkshelf.enabled = true
  config.vm.network "forwarded_port", guest: 8080, host: 8081
  config.vm.network "forwarded_port", guest: 80, host: 8080

  config.vm.provision :chef_solo do |chef|

    chef.json = {
        "apache" => {
            "contact" => "ops@example.com",
            "sites" => {
            }
        },
        "holland" => { "enabled" => "false" }
    }

    chef.run_list = [
      "recipe[lampstack::mysql_master]",
      "recipe[lampstack]"
    ]
  end
end
