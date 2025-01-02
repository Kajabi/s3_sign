# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new do |task|
  task.options = ["--display-cop-names"]
end

desc "Run the default task (RSpec tests)"
task default: :spec

desc "Run all RSpec tests"
task test: :spec

desc "Run Rubocop code analysis"
task rubocop: :rubocop
