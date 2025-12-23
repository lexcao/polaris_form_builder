# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test_unit) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_globs = [ "test/test_*.rb", "test/dev/*_test.rb" ]
end

task :test_integration do
  Dir.chdir("test/dummy") do
    puts "Test integration...#{pwd}"

    ENV["BUNDLE_GEMFILE"] = File.expand_path("Gemfile", pwd)
    sh("bin/rails test")
  end
end

task :test_playground do
  Dir.chdir("app/playground") do
    puts "Test playground...#{pwd}"

    ENV["BUNDLE_GEMFILE"] = File.expand_path("Gemfile", pwd)
    sh("bin/rails test")
  end
end

task test: [ :test_unit, :test_integration, :test_playground ]
task default: :test

# Load custom rake tasks
Dir["bin/tasks/**/*.rake"].each { |task| load task }
