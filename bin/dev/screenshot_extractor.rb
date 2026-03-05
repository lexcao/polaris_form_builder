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
      extract(html_content)
    end

    def extract(html_content)
      content = html_content.to_s

      matched = content.match(THUMBNAIL_PATTERN)
      if matched
        return matched[1]
      end

      matched = content.match(FALLBACK_PATTERN)
      if matched
        return matched[1]
      end

      matched = content.match(RELATIVE_THUMBNAIL_PATTERN)
      if matched
        return SHOPIFY_DOCS_HOST + matched[1]
      end

      matched = content.match(RELATIVE_FALLBACK_PATTERN)
      if matched
        return SHOPIFY_DOCS_HOST + matched[1]
      end

      nil
    end
  end
end
