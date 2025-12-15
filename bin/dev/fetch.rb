# frozen_string_literal: true

require "digest"
require "net/http"
require "uri"

def fetch(url)
  uri = URI(url)
  Net::HTTP.get(uri)
end

module Fetch
  CACHE_DIR = File.expand_path("tmp", __dir__)

  module_function

  def with_cache(url)
    file_path = cache_file_path(url)
    return File.read(file_path) if File.exist?(file_path)

    fetch(url).tap { |it| File.write(file_path, it) }
  end

  def cache_file_path(url)
    File.join(CACHE_DIR, cache_key(url))
  end

  def cache_key(url)
    "cache_" + Digest::SHA256.hexdigest(url)
  end
end
