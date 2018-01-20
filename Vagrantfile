# -*- mode: ruby -*-
# vi: set ft=ruby :

ENV['LC_ALL'] = 'C'

Vagrant.configure("2") do |config|
  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "ubuntu/xenial64"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.name = "ubuntu"
      vb.memory = "4096"
    end
    ubuntu.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get install -y build-essential
    SHELL
  end
end
