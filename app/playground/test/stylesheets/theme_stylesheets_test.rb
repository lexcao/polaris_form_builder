# frozen_string_literal: true

require "test_helper"

class ThemeStylesheetsTest < ActiveSupport::TestCase
  test "playground stylesheets only keep the light theme" do
    global_stylesheet = Rails.root.join("app/assets/stylesheets/_global.css").read
    base_stylesheet = Rails.root.join("app/assets/stylesheets/base.css").read

    refute_includes global_stylesheet, "html[data-theme=\"dark\"]"
    refute_includes global_stylesheet, "@media (prefers-color-scheme: dark)"
    refute_includes base_stylesheet, "html[data-theme=\"dark\"]"
    refute_includes base_stylesheet, "@media (prefers-color-scheme: dark)"
  end
end
