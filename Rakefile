# frozen_string_literal: true

require "bundler/gem_tasks"
require "minitest/test_task"

Minitest::TestTask.create(:test_unit) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_globs = [ "test/test_*.rb", "test/dev/*_test.rb" ]
end

task :test_integration do
  dummy_gemfile = File.expand_path("test/dummy/Gemfile", __dir__)

  Dir.chdir("test/dummy") do
    sh({ "BUNDLE_GEMFILE" => dummy_gemfile }, "bundle exec rails test")
  end
end

task :test_playground do
  playground_gemfile = File.expand_path("app/playground/Gemfile", __dir__)

  Dir.chdir("app/playground") do
    sh({ "BUNDLE_GEMFILE" => playground_gemfile, "RAILS_ENV" => "test" }, "bundle exec rails db:prepare")
    sh({ "BUNDLE_GEMFILE" => playground_gemfile, "RAILS_ENV" => "test" }, "bundle exec rails test")
  end
end

task test: [ :test_unit, :test_integration, :test_playground ]
task default: :test
