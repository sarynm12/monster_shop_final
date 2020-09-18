class Discount < ApplicationRecord

  belongs_to :merchant
  validates_presence_of :discount_percentage
  validates_presence_of :minimum_quantity

end
