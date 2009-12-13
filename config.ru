#!/usr/bin/env ruby

use Rack::ShowExceptions

require 'lib/watchtower'

begin
  require 'ipaddr'
  require 'rack/bug'
  require 'rack/bug/panels/mustache_panel'

  use Rack::Bug,
  :password => nil,
  :ip_masks => [IPAddr.new("127.0.0.1"), IPAddr.new("::1")],
  :panel_classes => [
    Rack::Bug::TimerPanel,
    Rack::Bug::RequestVariablesPanel,
    Rack::Bug::MustachePanel,
    Rack::Bug::MemoryPanel
  ]
rescue LoadError
  puts "=> gem install rack-bug to activate Rack::Bug"
end

# Load configuration and initialize Watchtower
Watchtower.new(File.dirname(__FILE__) + "/config/config.yml")

# You probably don't want to edit anything below
Watchtower::App.set :environment, ENV["RACK_ENV"] || :production
Watchtower::App.set :port,        8910

run Watchtower::App
