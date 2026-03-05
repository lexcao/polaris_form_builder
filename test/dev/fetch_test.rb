# frozen_string_literal: true

require "minitest/autorun"
require "fileutils"
require_relative "../../bin/dev/fetch"

class FetchTest < Minitest::Test
  def setup
    @url = "https://example.com/cache-test"
    @path = Fetch.cache_file_path(@url)
    FileUtils.rm_f(@path)
  end

  def teardown
    FileUtils.rm_f(@path)
  end

  def test_fetches_and_writes_cache_when_file_missing
    now = Time.utc(2026, 3, 5, 9, 0, 0)

    body = Fetch.stub(:fetch_remote, "fresh content") do
      Fetch.with_cache(@url, now: now)
    end

    assert_equal "fresh content", body
    assert File.exist?(@path)
    assert_equal "fresh content", File.read(@path)
  end

  def test_reuses_cache_within_same_day
    now = Time.utc(2026, 3, 5, 10, 0, 0)
    FileUtils.mkdir_p(File.dirname(@path))
    File.write(@path, "cached content")
    File.utime(now - 3600, now - 3600, @path)

    body = Fetch.stub(:fetch_remote, "new content") do
      Fetch.with_cache(@url, now: now)
    end

    assert_equal "cached content", body
    assert_equal "cached content", File.read(@path)
  end

  def test_refreshes_cache_on_next_day
    now = Time.utc(2026, 3, 5, 10, 0, 0)
    yesterday = now - 86_400
    FileUtils.mkdir_p(File.dirname(@path))
    File.write(@path, "stale content")
    File.utime(yesterday, yesterday, @path)

    body = Fetch.stub(:fetch_remote, "new content") do
      Fetch.with_cache(@url, now: now)
    end

    assert_equal "new content", body
    assert_equal "new content", File.read(@path)
  end
end
