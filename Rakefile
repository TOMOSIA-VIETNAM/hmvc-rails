# frozen_string_literal: true

require "bundler/gem_tasks"
require "rubocop/rake_task"
require "rake/testtask"

RuboCop::RakeTask.new
Rake::TestTask.new do |t|
  t.libs << "test"
end

task default: :rubocop
task default: :test
