require "test_helper"

class RestaurantsControllerTest < ActionDispatch::IntegrationTest
  include ApiTestHelper

  def setup
    Restaurant.destroy_all
    @restaurant = Restaurant.create!(
      name: "Somboon Seafood",
      address: "169/7-12 Surawong Rd, Bangkok",
      phone: "+66 2 233 3104",
      opening_hours: "Mon-Sun 16:00 - 23:00"
    )
    @menu_item = @restaurant.menu_items.create!(
      name: "Tom Yum Kung",
      price: 320,
      category: "main"
    )
  end

  # ─── GET /restaurants ────────────────────────────────────────────────────

  test "GET /restaurants returns 200 with list" do
    get restaurants_url, headers: json_headers
    assert_response :ok
    assert_equal 1, json_body["data"].length
    assert_equal "Somboon Seafood", json_body["data"][0]["name"]
  end

  test "GET /restaurants includes pagination meta" do
    get restaurants_url, headers: json_headers
    meta = json_body["meta"]
    assert_equal 1, meta["current_page"]
    assert_equal 1, meta["total_count"]
  end

  # ─── POST /restaurants ───────────────────────────────────────────────────

  test "POST /restaurants creates restaurant and returns 201" do
    assert_difference("Restaurant.count", 1) do
      post_json restaurants_url, restaurant: { name: "New Resto", address: "Jl. Baru No. 1" }
    end
    assert_response :created
    assert_equal "New Resto", json_body["data"]["name"]
  end

  test "POST /restaurants returns 422 without name" do
    assert_no_difference("Restaurant.count") do
      post_json restaurants_url, restaurant: { address: "Jl. Baru No. 1" }
    end
    assert_response :unprocessable_entity
    assert json_body["errors"].any? { |e| e.include?("Name") }
  end

  test "POST /restaurants returns 422 without address" do
    assert_no_difference("Restaurant.count") do
      post_json restaurants_url, restaurant: { name: "No Address Resto" }
    end
    assert_response :unprocessable_entity
    assert json_body["errors"].any? { |e| e.include?("Address") }
  end

  # ─── GET /restaurants/:id ────────────────────────────────────────────────

  test "GET /restaurants/:id returns 200 with menu_items included" do
    get restaurant_url(@restaurant), headers: json_headers
    assert_response :ok
    assert_equal @restaurant.name, json_body["data"]["name"]
    assert_equal 1, json_body["data"]["menu_items"].length
    assert_equal "Tom Yum Kung", json_body["data"]["menu_items"][0]["name"]
  end

  test "GET /restaurants/:id returns 404 for missing restaurant" do
    get restaurant_url(id: 999_999), headers: json_headers
    assert_response :not_found
    assert_includes json_body["error"], "not found"
  end

  # ─── PUT /restaurants/:id ────────────────────────────────────────────────

  test "PUT /restaurants/:id updates and returns 200" do
    put_json restaurant_url(@restaurant), restaurant: { name: "Updated Name", address: @restaurant.address }
    assert_response :ok
    assert_equal "Updated Name", json_body["data"]["name"]
    assert_equal "Updated Name", @restaurant.reload.name
  end

  test "PUT /restaurants/:id returns 404 for missing restaurant" do
    put_json restaurant_url(id: 999_999), restaurant: { name: "X", address: "Y" }
    assert_response :not_found
  end

  test "PUT /restaurants/:id returns 422 with invalid data" do
    put_json restaurant_url(@restaurant), restaurant: { name: "" }
    assert_response :unprocessable_entity
  end

  # ─── DELETE /restaurants/:id ─────────────────────────────────────────────

  test "DELETE /restaurants/:id returns 204 and removes record" do
    assert_difference("Restaurant.count", -1) do
      delete restaurant_url(@restaurant), headers: json_headers
    end
    assert_response :no_content
  end

  test "DELETE /restaurants/:id cascades to menu items" do
    assert_difference("MenuItem.count", -1) do
      delete restaurant_url(@restaurant), headers: json_headers
    end
  end

  test "DELETE /restaurants/:id returns 404 for missing restaurant" do
    delete restaurant_url(id: 999_999), headers: json_headers
    assert_response :not_found
  end
end
