require 'rubygems'
require 'bundler'
Bundler.require
require 'rspec/core/rake_task'
require "bundler/gem_tasks"

RSpec::Core::RakeTask.new(:spec)

desc "run spec"
task :default => [:spec]

desc "run travis build"
task :travis do
  exec "bundle exec rake SPEC_OPTS='--format documentation'"
end

namespace :print do
  task :script do
    require 'vx/message/testing'
    require File.expand_path("../spec/support/fixture", __FILE__)
    require File.expand_path("../spec/support/create", __FILE__)

    task = create :task
    source = create :source

    builder = Vx::Builder::ScriptBuilder.new(task, source)

    puts "\n#===> BEGIN BEFORE SCRIPT"
    puts builder.to_before_script
    puts "#===> END BEFORE SCRIPT\n"

    puts "\n#===> BEGIN SCRIPT\n"
    puts builder.to_script
    puts "#===> END SCRIPT\n\n"

    puts "\n#===> BEGIN AFTER SCRIPT\n"
    puts builder.to_after_script
    puts "#===> END AFTER SCRIPT\n\n"
  end
end
