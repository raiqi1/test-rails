puts "Seeding restaurants and menu items..."

# ─── Restaurant 1 ───────────────────────────────────────────────────────────

somboon = Restaurant.find_or_create_by!(name: "Somboon Seafood") do |r|
  r.address       = "169/7-12 Surawong Rd, Bang Rak, Bangkok 10500"
  r.phone         = "+66 2 233 3104"
  r.opening_hours = "Mon-Sun 16:00 - 23:00"
end

[
  {
    name: "Tom Yum Kung",
    description: "Spicy and sour prawn soup with lemongrass, kaffir lime leaves, and galangal",
    price: 320,
    category: "main",
    is_available: true
  },
  {
    name: "Pad Thai Goong Sod",
    description: "Classic stir-fried rice noodles with fresh prawns, egg, bean sprouts, and ground peanuts",
    price: 280,
    category: "main",
    is_available: true
  },
  {
    name: "Fried Soft Shell Crab",
    description: "Crispy golden soft shell crab with garlic and black pepper sauce",
    price: 450,
    category: "appetizer",
    is_available: true
  },
  {
    name: "Mango Sticky Rice",
    description: "Sweet glutinous rice topped with fresh mango slices and coconut cream",
    price: 120,
    category: "dessert",
    is_available: true
  },
  {
    name: "Thai Iced Tea",
    description: "Strong Ceylon tea sweetened with sugar and condensed milk, served over ice",
    price: 65,
    category: "drink",
    is_available: true
  }
].each { |attrs| somboon.menu_items.find_or_create_by!(name: attrs[:name]) { |mi| mi.assign_attributes(attrs) } }

# ─── Restaurant 2 ───────────────────────────────────────────────────────────

gaggan = Restaurant.find_or_create_by!(name: "Gaggan Anand") do |r|
  r.address       = "68/1 Soi Langsuan, Lumphini, Pathum Wan, Bangkok 10330"
  r.phone         = "+66 2 652 1700"
  r.opening_hours = "Tue-Sun 18:00 - 00:00"
end

[
  {
    name: "Yogurt Explosion",
    description: "Signature edible sphere bursting with lemon yogurt — one of the most iconic bites in Asia",
    price: 280,
    category: "appetizer",
    is_available: true
  },
  {
    name: "Charcoal Lamb Chop",
    description: "Slow-cooked Rajasthani-spiced lamb chop with mint chutney and pickled onions",
    price: 890,
    category: "main",
    is_available: true
  },
  {
    name: "Potato 'Chaat'",
    description: "Crispy puffed potato with tamarind water, yogurt foam, and pomegranate",
    price: 320,
    category: "appetizer",
    is_available: true
  },
  {
    name: "Gulab Jamun Modernist",
    description: "Deconstructed rose water milk dumplings with saffron ice cream and pistachio crumble",
    price: 350,
    category: "dessert",
    is_available: true
  },
  {
    name: "Mango Lassi",
    description: "Chilled blended Alphonso mango with house-made yogurt and a hint of cardamom",
    price: 180,
    category: "drink",
    is_available: true
  }
].each { |attrs| gaggan.menu_items.find_or_create_by!(name: attrs[:name]) { |mi| mi.assign_attributes(attrs) } }

puts "Done! #{Restaurant.count} restaurants, #{MenuItem.count} menu items seeded."
