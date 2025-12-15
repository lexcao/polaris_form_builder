# frozen_string_literal: true

require 'minitest/autorun'

require_relative '../../bin/dev/fetch'

class FetchTest < Minitest::Test
  def setup
    @url = 'https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield'
    skip 'Slow network test'
  end

  def test_fetch
    assert_not_empty fetch(@url)
  end

  def test_fetch_with_cache
    path = Fetch.cache_file_path(@url)
    File.delete(path) if File.exist?(path)

    assert_not File.exist?(path)
    body = Fetch.with_cache(@url)
    assert_not_empty body
    assert File.exist?(path)
  end
end
