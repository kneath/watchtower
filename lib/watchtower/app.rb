module Watchtower
  class App < Sinatra::Default
    set :root,     File.dirname(__FILE__) + "/../.."
    set :app_file, __FILE__
    enable :sessions

    include Watchtower

    register Mustache::Sinatra
    helpers Helpers

    dir = File.dirname(File.dirname(__FILE__) + "/../../..")

    # Tell mustache where the Views constant lives
    set :namespace, Watchtower

    # Mustache templates live here
    set :views,     "#{dir}/templates"

    # Tell mustache where the views are
    set :mustaches, "#{dir}/views"

    get '/' do
      show :index
    end

    get '/poll' do
      @results = Beam.poll_all
      show :poll, :layout => false
    end

  end
end