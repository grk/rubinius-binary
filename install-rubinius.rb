#!/usr/bin/env ruby

require 'fileutils'

def run(cmd)
  puts "running: #{cmd}"
  system cmd
end

def debian?
  File.exist?("/etc/debian_version")
end

def debian_version
  File.read("/etc/debian_version").strip
end

def debian_jessie?
  debian? &&
    debian_version == "jessie/sid"
end

rubinius_version = ARGV[0]

puts "installing #{rubinius_version}"

archive = "/vagrant/rbx-archives/#{rubinius_version}.tar.bz2"
builds = "/vagrant/rbx-build/"
build = File.join(builds, rubinius_version)

Dir.chdir '/vagrant'

unless File.exist?(archive)
  run "wget http://releases.rubini.us/#{rubinius_version}.tar.bz2 -O #{archive}"
end

run "tar -jxf #{archive} -C #{builds}"

Dir.chdir "#{build}"

bundler_path = Dir.glob("#{build}/vendor/cache/bundler-*.gem").first
run "sudo gem install #{bundler_path}"

if debian_jessie? && rubinius_version == "rubinius-2.2.3"
  # need to upgrade rubysl-openssl to 2.0.6 so that it compiles on debian
  # https://github.com/rubysl/rubysl-openssl/commit/799261c734ec0c28fb238092bf48e910eba32df6
  run "rm #{build}/vendor/cache/rubysl-openssl-*"
  run "wget http://rubygems.org/downloads/rubysl-openssl-2.0.6.gem -O #{build}/vendor/cache/rubysl-openssl-2.0.6.gem"
  run %{sed -i 's/\\["rubysl-openssl", "2.0.5"\\]/\\["rubysl-openssl", "2.0.6"\\]/g' #{build}/config.rb.in}
end

run "bundle install --local"

run "./configure --release-build"
run "rake package:binary"

distribution = `lsb_release -is`.strip.downcase
version = (debian? ? debian_version : `lsb_release -cs`.strip.downcase).tr('/', '_')
arch = `uname -m`.strip.downcase

binaries_path = "/vagrant/binaries/#{distribution}/#{version}/#{arch}"
FileUtils.mkdir_p binaries_path

run "mv #{rubinius_version}.tar* #{binaries_path}"
