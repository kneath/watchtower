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

namespace :app do
  task :setup do
    require "lib/burndown"
    Burndown.new(File.dirname(__FILE__) + "/config/config.yml")
  end
  
  task :update_milestones => :setup do
    Burndown::Milestone.sync_with_lighthouse
  end
end

task :environment do
  require "lib/burndown"
  Burndown.new(File.dirname(__FILE__) + "/config/config.yml")
end

task :cron => :environment do
  if Time.now.hour == 01
    puts "Updating milestones..."
    Burndown::Milestone.sync_with_lighthouse
    puts "done."
  end
end