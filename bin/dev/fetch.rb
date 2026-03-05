# frozen_string_literal: true

require "date"
require "digest"
require "fileutils"
require "net/http"
require "uri"

module Fetch
  CACHE_DIR = File.expand_path("tmp", __dir__)
  CACHE_PREFIX = "cache_"

  module_function

  def with_cache(url, now: Time.now.utc)
    ensure_cache_dir!
    file_path = cache_file_path(url)
    return File.read(file_path) if cache_fresh_today?(file_path, now)

    fetch_remote(url).tap { |it| File.write(file_path, it) }
  end

  def cache_file_path(url)
    File.join(CACHE_DIR, cache_key(url))
  end

  def cache_key(url)
    CACHE_PREFIX + Digest::SHA256.hexdigest(url)
  end

  def fetch_remote(url)
    uri = URI(url)
    Net::HTTP.get(uri)
  end

  def ensure_cache_dir!
    FileUtils.mkdir_p(CACHE_DIR)
  end

  def cache_fresh_today?(file_path, now)
    return false unless File.exist?(file_path)

    File.mtime(file_path).utc.to_date == now.to_date
  end
end
