# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../../bin/dev/meta_data'

class MetaDataTest < Minitest::Test
  def test
    assert_equal 17, MetaData.list.size
  end
end
