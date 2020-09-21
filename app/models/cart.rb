class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents || {}
    @contents.default = 0
  end

  def add_item(item_id)
    @contents[item_id] += 1
  end

  def less_item(item_id)
    @contents[item_id] -= 1
  end

  def count
    @contents.values.sum
  end

  def items
    @contents.map do |item_id, _|
      Item.find(item_id)
    end
  end

  def grand_total
    grand_total = 0.0
    @contents.each do |item_id, quantity|
      grand_total += Item.find(item_id).price * quantity
    end
    grand_total
  end

  def count_of(item_id)
    @contents[item_id.to_s]
  end

  def subtotal_of(item_id)
    @contents[item_id.to_s] * Item.find(item_id).price
  end

  def limit_reached?(item_id)
    count_of(item_id) == Item.find(item_id).inventory
  end

  def discount_eligible?(item_id, discount)
    count_of(item_id) >= discount.minimum_quantity
  end

  def check_discount(item_id)
    Item.find(item_id).merchant.discounts.each do |discount|
      if discount_eligible?(item_id, discount)
        return true
      else
        return false
      end
    end
  end

  def best_discount(item_id)
    Item.find(item_id).merchant.discounts.where("minimum_quantity <= ?", @contents[item_id.to_s]).maximum(:discount_percentage).to_f / 100.00
  end
end
