require "test_helper"

class MenuItemTest < ActiveSupport::TestCase
  def setup
    @restaurant = Restaurant.create!(name: "Test Resto", address: "Jl. Test No. 1")
  end

  def valid_item
    @restaurant.menu_items.new(name: "Ayam Goreng", price: 35_000)
  end

  test "valid with name and price" do
    assert valid_item.valid?
  end

  test "invalid without name" do
    item = valid_item
    item.name = ""
    assert_not item.valid?
    assert_includes item.errors[:name], "can't be blank"
  end

  test "invalid without price" do
    item = valid_item
    item.price = nil
    assert_not item.valid?
    assert_includes item.errors[:price], "can't be blank"
  end

  test "invalid with negative price" do
    item = valid_item
    item.price = -1
    assert_not item.valid?
  end

  test "valid with price zero" do
    item = valid_item
    item.price = 0
    assert item.valid?
  end

  test "valid with accepted categories" do
    %w[appetizer main dessert drink].each do |cat|
      item = valid_item
      item.category = cat
      assert item.valid?, "Expected '#{cat}' to be valid"
    end
  end

  test "invalid with unknown category" do
    item = valid_item
    item.category = "snack"
    assert_not item.valid?
    assert_match(/not valid/, item.errors[:category].first)
  end

  test "valid with blank category" do
    item = valid_item
    item.category = ""
    assert item.valid?
  end

  test "is_available defaults to true" do
    item = valid_item
    item.save!
    assert item.is_available
  end

  test "belongs to a restaurant" do
    assert_equal @restaurant, valid_item.restaurant
  end
end
