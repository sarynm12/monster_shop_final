require 'rails_helper'

RSpec.describe Discount do
  describe 'relationships' do
    it {should belong_to :merchant}
  end

  describe 'validations' do
    it {should validate_presence_of :discount_percentage}
    it {should validate_presence_of :minimum_quantity}
    it {should validate_numericality_of :discount_percentage}
    it {should validate_numericality_of :minimum_quantity}
    it {should validate_presence_of :description}
  end
end
