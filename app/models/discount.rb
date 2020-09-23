class Discount < ApplicationRecord

  belongs_to :merchant
  validates_presence_of :discount_percentage
  validates_presence_of :minimum_quantity
  validates_presence_of :description
  validates_numericality_of :discount_percentage, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
  validates_numericality_of :minimum_quantity

end
