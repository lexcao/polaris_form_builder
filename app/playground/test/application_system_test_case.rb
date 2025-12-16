# frozen_string_literal: true

require "test_helper"
require "capybara/shadowdom"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  parallelize(workers: 1)

  driven_by :selenium, using: :headless_chrome, screen_size: [ 1400, 1000 ]
end
