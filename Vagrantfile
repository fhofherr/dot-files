# -*- mode: ruby -*-
# vi: set ft=ruby sw=2:

ENV['LC_ALL'] = 'C'

Vagrant.configure("2") do |config|
  config.vm.define "ubuntu" do |ubuntu|
    ubuntu.vm.box = "bento/ubuntu-18.04"
    ubuntu.vm.hostname = "ubuntu"
    ubuntu.vm.provider "virtualbox" do |vb|
      vb.name = "ubuntu"
      vb.memory = "4096"
    end
    ubuntu.vm.provision "shell", inline: <<-SHELL
      apt-get update
      apt-get upgrade
      apt-get install -y build-essential
    SHELL
  end
end
