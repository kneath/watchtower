$:.unshift File.expand_path(File.dirname(__FILE__))

require 'sinatra/base'
require 'logger'

require 'mongo'
require 'mustache/sinatra'
require 'nokogiri'
require 'open-uri'
require 'digest/sha1'

require 'watchtower/beam'
require 'watchtower/beam/hacker_news'
require 'watchtower/beam/twitter'
require 'watchtower/helpers'
require 'watchtower/app'
require 'views/layout'

MONGO = Mongo::Connection.new.db("watchtower-#{Watchtower::App.environment}")
BEAMS = MONGO.collection('beams')

module Watchtower
  def self.new(config=nil)
    if config.is_a?(String) && File.file?(config)
      self.config = YAML.load_file(config)
    elsif config.is_a?(Hash)
      self.config = config
    end
  end

  def self.default_configuration
    @defaults ||= { :database_uri      => "sqlite3::memory:",
                    :log               => STDOUT,
                    :base_uri          => "http://localhost:8910",
                    :log_debug_info    => false }
  end

  def self.config
    @config ||= default_configuration.dup
  end

  def self.config=(options)
    @config = default_configuration.merge(options)
  end

  def self.log(message, &block)
    logger.info(message, &block)
  end

  def self.logger
    @logger ||= Logger.new(config[:log], "daily").tap do |logger|
      logger.formatter = LogFormatter.new
    end
  end
  private_class_method :logger

  class LogFormatter < Logger::Formatter
    def call(severity, time, progname, msg)
      time.strftime("[%H:%M:%S] ") + msg2str(msg) + "\n"
    end
  end
end