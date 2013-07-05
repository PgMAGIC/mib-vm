# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant::configure('2') do |config|
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
	v.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end
end

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  config.vm.boot_mode = :gui

  # Assign this VM to a host-only network IP, allowing you to access it
  # via the IP. Host-only networks can talk to the host machine as well as
  # any other machines on the same network, but cannot be accessed (through this
  # network interface) by any external networks.
  config.vm.network :hostonly, "192.168.33.12"

  # config.vm.network :bridged
  config.vm.forward_port 9001,9001
  config.vm.provision :shell, :inline => "/etc/init.d/networking restart"

  # Share an additional folder to the guest VM. The first argument is
  # an identifier, the second is the path on the guest to mount the
  # folder, and the third is the path on the host to the actual folder.
  # config.vm.share_folder "v-data", "/vagrant_data", "../data"

  config.vm.share_folder "templates", "/tmp/vagrant-puppet/templates", "./puppet/templates"


  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.module_path = "puppet/modules"
    puppet.options = ["--templatedir","/tmp/vagrant-puppet/templates"]
    puppet.manifest_file  = "base.pp"
  end

end
