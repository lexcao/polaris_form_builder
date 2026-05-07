# frozen_string_literal: true

require_relative "fetch"

class ScreenshotExtractor
  SHOPIFY_DOCS_HOST = "https://shopify.dev"
  SCREENSHOT_PATH = "templated-apis-screenshots/admin/components"
  THUMBNAIL_PATTERN = %r{\\"thumbnail\\",\\"(https://cdn\.shopify\.com[^\\"]*/#{Regexp.escape(SCREENSHOT_PATH)}/[^\\"]+\.png)}
  RELATIVE_THUMBNAIL_PATTERN = %r{\\"thumbnail\\",\\"(/images/#{Regexp.escape(SCREENSHOT_PATH)}/[^\\"]+\.png)}
  FALLBACK_PATTERN = %r{(https://cdn\.shopify\.com[^"'\s\\]*/#{Regexp.escape(SCREENSHOT_PATH)}/[^"'\s\\]+\.png)}
  RELATIVE_FALLBACK_PATTERN = %r{(/images/#{Regexp.escape(SCREENSHOT_PATH)}/[^"'\s\\]+\.png)}

  class << self
    def fetch(page_url)
      html_content = Fetch.with_cache(page_url)
      extract(html_content, slug: slug_from(page_url))
    end

    def extract(html_content, slug: nil)
      content = html_content.to_s
      urls = screenshot_urls(content)
      if slug
        matched_url = urls.find { |url| screenshot_matches_slug?(url, slug) }
        return matched_url if matched_url
      end

      urls.first
    end

    def screenshot_urls(content)
      [
        content.scan(THUMBNAIL_PATTERN).flatten,
        content.scan(FALLBACK_PATTERN).flatten,
        content.scan(RELATIVE_THUMBNAIL_PATTERN).flatten.map { |path| SHOPIFY_DOCS_HOST + path },
        content.scan(RELATIVE_FALLBACK_PATTERN).flatten.map { |path| SHOPIFY_DOCS_HOST + path }
      ].flatten.uniq
    end

    def screenshot_matches_slug?(url, slug)
      candidates = [ slug, slug.delete("-") ].uniq
      basename = File.basename(url, ".png")

      candidates.any? do |candidate|
        basename == candidate || basename.start_with?("#{candidate}-")
      end
    end

    def slug_from(page_url)
      File.basename(URI(page_url).path)
    end
  end
end
