require "test_helper"

class RestaurantTest < ActiveSupport::TestCase
  def valid_restaurant
    Restaurant.new(name: "Test Resto", address: "Jl. Test No. 1")
  end

  test "valid with name and address" do
    assert valid_restaurant.valid?
  end

  test "invalid without name" do
    r = valid_restaurant
    r.name = ""
    assert_not r.valid?
    assert_includes r.errors[:name], "can't be blank"
  end

  test "invalid without address" do
    r = valid_restaurant
    r.address = ""
    assert_not r.valid?
    assert_includes r.errors[:address], "can't be blank"
  end

  test "phone and opening_hours are optional" do
    r = valid_restaurant
    r.phone = nil
    r.opening_hours = nil
    assert r.valid?
  end

  test "has many menu items" do
    r = valid_restaurant
    r.save!
    r.menu_items.create!(name: "Nasi Goreng", price: 25_000)
    assert_equal 1, r.menu_items.count
  end

  test "destroys menu items when deleted" do
    r = valid_restaurant
    r.save!
    r.menu_items.create!(name: "Nasi Goreng", price: 25_000)
    assert_difference("MenuItem.count", -1) { r.destroy }
  end
end
