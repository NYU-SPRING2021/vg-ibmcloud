# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # Use Ubuntu 18.04
  config.vm.box = "ubuntu/bionic64"

  # Set up network port forwarding
  config.vm.network "forwarded_port", guest: 8001, host: 8001, host_ip: "127.0.0.1"
  config.vm.network "private_network", ip: "192.168.33.10"
  config.vm.hostname = "ibmcloudml"

  # Keep the VM as lean as possible
  config.vm.provider "virtualbox" do |vb|
    # Customize the amount of memory on the VM:
    vb.memory = "1024"
    vb.cpus = 2
    # Fixes DNS issues on some networks
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
  end

  ## Copy your .gitconfig file so that your git credentials are correct
  #if File.exists?(File.expand_path("~/.gitconfig"))
  #  config.vm.provision "file", source: "~/.gitconfig", destination: "~/.gitconfig"
  #end
#
#  # Copy your ssh keys for github so that your git credentials work
#  if File.exists?(File.expand_path("~/.ssh/id_rsa"))
#    config.vm.provision "file", source: "~/.ssh/id_rsa", destination: "~/.ssh/id_rsa"
#  end
#
#  # Copy your .vimrc file so that your VI editor looks right
#  if File.exists?(File.expand_path("~/.vimrc"))
#    config.vm.provision "file", source: "~/.vimrc", destination: "~/.vimrc"
#  end
#
#  # Copy your apiKey.json file so that you can login to IBM Cloud with a token
#  if File.exists?(File.expand_path("~/.bluemix/apiKey.json"))
#    config.vm.provision "file", source: "~/.bluemix/apiKey.json", destination: "~/.bluemix/apiKey.json"
#  end
#
#  ######################################################################
  # Make sure that git and other dev utilities are available
  ######################################################################
  config.vm.provision "shell", inline: <<-SHELL
    apt-get update
    sudo dpkg --configure -a
    apt-get install -y git curl wget zip tree
    # Set up a Python 3 environment
    apt-get install -y python3-dev python3-pip python3-venv
    python3 -m venv venv
    apt-get -y autoremove
  SHELL

  ######################################################################
  # Add docker image before IBM Cloud
  ######################################################################
  config.vm.provision "docker" do |d|
    d.pull_images "alpine:latest"
  end

  ######################################################################
  # Setup a IBM Cloud and Kubernetes environment
  ######################################################################
  config.vm.provision "shell", inline: <<-SHELL
    echo "\n************************************"
    echo " Installing IBM Cloud CLI..."
    echo "************************************\n"
    # Install IBM Cloud CLI as Vagrant user
    sudo -H -u vagrant sh -c 'curl -sL http://ibm.biz/idt-installer | bash'
    sudo -H -u vagrant sh -c "echo 'source <(kubectl completion bash)' >> ~/.bashrc"
    sudo -H -u vagrant sh -c "echo alias ic=/usr/local/bin/ibmcloud >> ~/.bash_aliases"
    sudo -H -u vagrant sh -c "bx plugin install machine-learning"
    echo "\n"
    echo "\n************************************"
    echo " IBM Cloud setup complete\n"
    echo " You can use alisas ic for ibmcloud command\n"
    echo " For the Kubernetes Dashboard use:"
    echo " kubectl proxy --address='0.0.0.0'\n"
    echo " Then open a browser to: http://localhost:8001/ui \n"
    echo "************************************\n"
  SHELL
end
