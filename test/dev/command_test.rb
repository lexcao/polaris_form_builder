# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "rbconfig"

class CommandTest < Minitest::Test
  def test_bootstraps_bundler_before_loading_dependencies
    command_path = File.expand_path("../../bin/command", __dir__)
    source = File.read(command_path)

    assert_includes source, 'ENV["BUNDLE_GEMFILE"] ||='
    assert_includes source, 'require "bundler/setup"'
  end

  def test_prints_usage_without_arguments
    command_path = File.expand_path("../../bin/command", __dir__)
    env = {
      "HOME" => ENV.fetch("HOME"),
      "PATH" => ENV.fetch("PATH"),
      "RUBYOPT" => ""
    }

    output, status = Open3.capture2e(env, RbConfig.ruby, command_path)

    assert_equal 1, status.exitstatus
    assert_includes output, "Usage:"
  end
end
