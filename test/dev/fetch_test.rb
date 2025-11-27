require 'minitest/autorun'

require_relative '../../bin/dev/fetch'

class FetchTest < Minitest::Test
  def setup
    @url = "https://shopify.dev/docs/api/app-home/polaris-web-components/forms/textfield"
  end

  def test_fetch
    refute_empty fetch(@url)
  end

  def test_fetch_with_cache
    cache_file_path = Fetch.cache_file_path(@url)
    File.delete(cache_file_path) if File.exist?(cache_file_path)

    refute File.exist?(cache_file_path)
    body = Fetch.with_cache(@url)
    refute_empty body
    assert File.exist?(cache_file_path)
  end
end
