#!/usr/bin/env ruby

require 'yaml'

configuration = YAML::load_file('config.yml')
binaries = ENV.has_key?("RUBY_VERSIONS") ? ENV["RUBY_VERSIONS"].split(/ /) : configuration["binaries"]
distributions = configuration["distributions"]

Vagrant.configure("2") do |config|
  distributions.each do |name, url|
    config.vm.define name.to_sym do |definition|
      definition.vm.box = name
      definition.vm.box_url = url
      definition.vm.provider(:virtualbox) {|vb| vb.name = "rbx-binary-#{name.tr('_', '-')}"}
    end
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      "modifyvm", :id,
      "--memory", "1024",
      "--cpus", "2",
      "--ioapic", "on",
    ]
    # vb.gui = true
  end

  config.vm.provision :shell, :path => "setup-vm.sh"
  binaries.each do |binary|
    config.vm.provision :shell, :path => "install-rubinius.rb", :args => binary
  end
  config.vm.provision :shell, :path => "cleanup-rubinius.sh"
end
