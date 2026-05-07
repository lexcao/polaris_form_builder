# frozen_string_literal: true

require "minitest/autorun"
require "fileutils"
require "socket"
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

  def test_fetch_remote_follows_redirects
    with_test_server do |base_url|
      body = Fetch.fetch_remote("#{base_url}/old")

      assert_equal "redirected content", body
    end
  end

  private
    def with_test_server
      server = TCPServer.new("127.0.0.1", 0)
      thread = Thread.new do
        loop do
          client = server.accept
          request_line = client.gets
          client.gets until client.gets == "\r\n"

          if request_line.start_with?("GET /old ")
            client.write "HTTP/1.1 301 Moved Permanently\r\nLocation: /new\r\nContent-Length: 0\r\n\r\n"
          else
            client.write "HTTP/1.1 200 OK\r\nContent-Length: 18\r\n\r\nredirected content"
          end
          client.close
        end
      rescue IOError
      end
      yield "http://127.0.0.1:#{server.addr[1]}"
    ensure
      server&.close
      thread&.join
    end
end
