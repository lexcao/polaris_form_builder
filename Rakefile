# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test_unit) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_globs = [ "test/test_*.rb", "test/dev/*_test.rb" ]
end

task :test_integration do
  puts "Test integration..."
  Dir.chdir("test/dummy") do
    sh("bin/rails test")
  end
end

task :test_playground do
  puts "Test playground..."
  Dir.chdir("app/playground") do
    sh("bin/rails test")
  end
end

task test: [ :test_unit, :test_integration, :test_playground ]
task default: :test
