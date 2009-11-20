$:.unshift File.dirname(__FILE__) + "/../lib", File.dirname(__FILE__)

require "rubygems"

require "test/unit"
require "rr"
require "mocha"
require "dm-sweatshop"
require "webrat/sinatra"

gem "jeremymcanally-context"
gem "jeremymcanally-matchy"
require "context"
require "matchy"

require "burndown"
require "helpers/expectations"
require "blueprints"

begin
  require "ruby-debug"
  require "redgreen"
rescue LoadError
end

class Test::Unit::TestCase

  include RR::Adapters::TestUnit
  include Burndown

  before(:all) do
    DataMapper.setup(:default, "sqlite3::memory:")
    DataMapper.auto_migrate!
  end

  before(:each) do
    RR.reset
  end
end
