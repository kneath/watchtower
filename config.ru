#!/usr/bin/env ruby
require 'lib/watchtower'

# Load configuration and initialize Watchtower
Watchtower.new(File.dirname(__FILE__) + "/config/config.yml")

# You probably don't want to edit anything below
Watchtower::App.set :environment, ENV["RACK_ENV"] || :production
Watchtower::App.set :port,        8910

run Watchtower::App
