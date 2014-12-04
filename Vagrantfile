# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "chef-uptime"
  config.omnibus.chef_version = :latest
  config.vm.box = "chef/ubuntu-14.04"
  config.vm.network "private_network", ip: "55.55.55.55"
  config.berkshelf.enabled = true

  config.vm.provision :chef_solo do |chef|
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      },
      uptime_app: {
          mongodb: {
              user: 'admin',
              password: 'admin'
          }
      }

    }
    chef.run_list = [
        "recipe[uptime::default]"
    ]
  end
end