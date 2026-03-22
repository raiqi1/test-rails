require "test_helper"

class MenuItemsControllerTest < ActionDispatch::IntegrationTest
  include ApiTestHelper

  def setup
    Restaurant.destroy_all
    @restaurant = Restaurant.create!(name: "Test Resto", address: "Jl. Test No. 1")
    @appetizer = @restaurant.menu_items.create!(name: "Spring Roll", price: 50_000, category: "appetizer")
    @main      = @restaurant.menu_items.create!(name: "Nasi Goreng", price: 35_000, category: "main")
    @drink     = @restaurant.menu_items.create!(name: "Es Teh", price: 10_000, category: "drink")
  end

  # ─── GET /restaurants/:id/menu_items ─────────────────────────────────────

  test "GET /restaurants/:id/menu_items returns 200 with all items" do
    get restaurant_menu_items_url(@restaurant), headers: json_headers
    assert_response :ok
    assert_equal 3, json_body["data"].length
  end

  test "GET /restaurants/:id/menu_items filters by category" do
    get restaurant_menu_items_url(@restaurant), params: { category: "main" }, headers: json_headers
    assert_response :ok
    assert_equal 1, json_body["data"].length
    assert_equal "Nasi Goreng", json_body["data"][0]["name"]
  end

  test "GET /restaurants/:id/menu_items searches by name" do
    get restaurant_menu_items_url(@restaurant), params: { name: "teh" }, headers: json_headers
    assert_response :ok
    assert_equal 1, json_body["data"].length
    assert_equal "Es Teh", json_body["data"][0]["name"]
  end

  test "GET /restaurants/:id/menu_items returns 404 for missing restaurant" do
    get restaurant_menu_items_url(restaurant_id: 999_999), headers: json_headers
    assert_response :not_found
  end

  test "GET /restaurants/:id/menu_items includes pagination meta" do
    get restaurant_menu_items_url(@restaurant), headers: json_headers
    meta = json_body["meta"]
    assert_not_nil meta["current_page"]
    assert_not_nil meta["total_count"]
  end

  # ─── POST /restaurants/:id/menu_items ────────────────────────────────────

  test "POST /restaurants/:id/menu_items creates item and returns 201" do
    assert_difference("MenuItem.count", 1) do
      post_json restaurant_menu_items_url(@restaurant),
                menu_item: { name: "Sate Ayam", price: 25_000, category: "main" }
    end
    assert_response :created
    assert_equal "Sate Ayam", json_body["data"]["name"]
  end

  test "POST /restaurants/:id/menu_items returns 422 without name" do
    assert_no_difference("MenuItem.count") do
      post_json restaurant_menu_items_url(@restaurant), menu_item: { price: 20_000 }
    end
    assert_response :unprocessable_entity
    assert json_body["errors"].any? { |e| e.include?("Name") }
  end

  test "POST /restaurants/:id/menu_items returns 422 with invalid category" do
    assert_no_difference("MenuItem.count") do
      post_json restaurant_menu_items_url(@restaurant),
                menu_item: { name: "Snack", price: 10_000, category: "snack" }
    end
    assert_response :unprocessable_entity
  end

  test "POST /restaurants/:id/menu_items returns 422 with negative price" do
    assert_no_difference("MenuItem.count") do
      post_json restaurant_menu_items_url(@restaurant),
                menu_item: { name: "Free Item", price: -1 }
    end
    assert_response :unprocessable_entity
  end

  test "POST /restaurants/:id/menu_items returns 404 for missing restaurant" do
    post_json restaurant_menu_items_url(restaurant_id: 999_999),
              menu_item: { name: "Item", price: 10_000 }
    assert_response :not_found
  end

  # ─── PUT /menu_items/:id ─────────────────────────────────────────────────

  test "PUT /menu_items/:id updates item and returns 200" do
    put_json menu_item_url(@main), menu_item: { name: "Nasi Goreng Spesial", price: 45_000 }
    assert_response :ok
    assert_equal "Nasi Goreng Spesial", json_body["data"]["name"]
    assert_equal "45000.0", json_body["data"]["price"]
  end

  test "PUT /menu_items/:id can toggle availability" do
    put_json menu_item_url(@main), menu_item: { is_available: false }
    assert_response :ok
    assert_equal false, json_body["data"]["is_available"]
  end

  test "PUT /menu_items/:id returns 404 for missing item" do
    put_json menu_item_url(id: 999_999), menu_item: { name: "X", price: 1 }
    assert_response :not_found
  end

  test "PUT /menu_items/:id returns 422 with invalid data" do
    put_json menu_item_url(@main), menu_item: { price: -100 }
    assert_response :unprocessable_entity
  end

  # ─── DELETE /menu_items/:id ──────────────────────────────────────────────

  test "DELETE /menu_items/:id returns 204 and removes item" do
    assert_difference("MenuItem.count", -1) do
      delete menu_item_url(@appetizer), headers: json_headers
    end
    assert_response :no_content
  end

  test "DELETE /menu_items/:id returns 404 for missing item" do
    delete menu_item_url(id: 999_999), headers: json_headers
    assert_response :not_found
  end
end
