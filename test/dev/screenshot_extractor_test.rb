# frozen_string_literal: true

require "minitest/autorun"
require_relative "../../bin/dev/screenshot_extractor"

class ScreenshotExtractorTest < Minitest::Test
  def test_extract_returns_thumbnail_url_from_stream_payload
    html = <<~HTML
      <script>
      window.__reactRouterContext.streamController.enqueue("[\\"thumbnail\\",\\"https://cdn.shopify.com/shopifycloud/shopify-dev/production/assets/assets/images/templated-apis-screenshots/admin/components/checkbox-DFmfCiT4.png\\"]");
      </script>
    HTML

    assert_equal(
      "https://cdn.shopify.com/shopifycloud/shopify-dev/production/assets/assets/images/templated-apis-screenshots/admin/components/checkbox-DFmfCiT4.png",
      ScreenshotExtractor.extract(html)
    )
  end

  def test_extract_returns_nil_when_no_screenshot_exists
    html = "<html><body>No screenshot here</body></html>"

    assert_nil ScreenshotExtractor.extract(html)
  end

  def test_extract_supports_relative_screenshot_path
    html = <<~HTML
      <script>
      window.__reactRouterContext.streamController.enqueue("[\\"thumbnail\\",\\"/images/templated-apis-screenshots/admin/components/textfield-D5zp62-y.png\\"]");
      </script>
    HTML

    assert_equal(
      "https://shopify.dev/images/templated-apis-screenshots/admin/components/textfield-D5zp62-y.png",
      ScreenshotExtractor.extract(html)
    )
  end
end
