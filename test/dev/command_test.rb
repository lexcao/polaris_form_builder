# frozen_string_literal: true

require "minitest/autorun"
require "open3"
require "rbconfig"
require_relative "../../bin/dev/command"

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

  def test_sync_fails_when_every_component_is_skipped
    component = MetaData::Result.new(
      key: "checkbox",
      name: "Checkbox",
      markdown_content: "Moved Permanently. Redirecting to /docs/api/app-home/web-components/forms/checkbox.md",
      markdown_url: "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/checkbox.md"
    )

    _, stderr = capture_io do
      error = assert_raises(RuntimeError) do
        MetaData.stub(:fetch_all, [ component ]) do
          Command::Sync.new.run
        end
      end

      assert_includes error.message, "sync parsed 0 components"
    end

    assert_includes stderr, "skip parse Checkbox"
  end
end
