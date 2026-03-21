class MenuItem < ApplicationRecord
  belongs_to :restaurant

  CATEGORIES = %w[appetizer main dessert drink].freeze

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :category, inclusion: { in: CATEGORIES, message: "'%{value}' is not valid. Must be one of: #{CATEGORIES.join(', ')}" }, allow_blank: true
end
