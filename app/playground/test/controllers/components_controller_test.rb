require "test_helper"

class ComponentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get components_url
    assert_response :success
  end

  test "index renders component cards with dashed border" do
    get components_url
    assert_response :success

    assert_select 's-box[border="base base dashed"]'
  end

  test "index renders all components sorted by name" do
    get components_url
    assert_response :success

    component_names = css_select('s-box[border="base base dashed"] s-text[type=strong]').map(&:text)
    assert_equal component_names, component_names.sort
  end

  test "index renders component screenshot images" do
    get components_url
    assert_response :success

    assert_select "s-image[src*='shopify.dev'][src*='components']"
  end
end
