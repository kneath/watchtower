require "rake/testtask"

desc "Default: run all tests"
task :default => :test

desc "Run tests"
task :test => %w(test:units test:acceptance)
namespace :test do
  desc "Run unit tests"
  Rake::TestTask.new(:units) do |t|
    t.test_files = FileList["test/unit/*_test.rb"]
  end

  desc "Run acceptance tests"
  Rake::TestTask.new(:acceptance) do |t|
    t.test_files = FileList["test/acceptance/*_test.rb"]
  end
end

namespace :mongodb do
  desc "Start MongoDB for development"
  task :start do
    mkdir_p "db"
    system "mongod --dbpath db/"
  end
end

namespace :app do
  task :environment do
    require "lib/watchtower"
    Watchtower.new(File.dirname(__FILE__) + "/config/config.yml")
  end

  task :poll => :environment do
    Watchtower::Beam.poll_all
  end

  desc "Start Haystack for development"
  task :start do
    system "shotgun config.ru"
  end
end

multitask :start => [ 'mongodb:start', 'app:start' ]