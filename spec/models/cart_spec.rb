require 'rails_helper'

RSpec.describe Cart do
  describe 'instance methods' do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 2 )
      @monster = @megan.items.create!(name: 'Monster', description: 'Stuffed Animal', price: 10, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 10)
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @cart = Cart.new({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
      @cart2 = Cart.new({
        @ogre.id.to_s => 2,
        @monster.id.to_s => 5})
      @discount1 = @megan.discounts.create!(discount_percentage: 10, minimum_quantity: 5, description: '10% off when you buy 5 or more items')
    end

    it '.contents' do
      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2
        })
    end

    it '.add_item()' do
      @cart.add_item(@hippo.id.to_s)

      expect(@cart.contents).to eq({
        @ogre.id.to_s => 1,
        @giant.id.to_s => 2,
        @hippo.id.to_s => 1
        })
    end

    it '.count' do
      expect(@cart.count).to eq(3)
    end

    it '.items' do
      expect(@cart.items).to eq([@ogre, @giant])
    end

    it '.grand_total' do
      expect(@cart.grand_total).to eq(120)
    end

    it '.count_of()' do
      expect(@cart.count_of(@ogre.id)).to eq(1)
      expect(@cart.count_of(@giant.id)).to eq(2)
    end

    it '.subtotal_of()' do
      expect(@cart.subtotal_of(@ogre.id)).to eq(20)
      expect(@cart.subtotal_of(@giant.id)).to eq(100)
    end

    it '.limit_reached?()' do
      expect(@cart.limit_reached?(@ogre.id)).to eq(false)
      expect(@cart.limit_reached?(@giant.id)).to eq(true)
    end

    it '.less_item()' do
      @cart.less_item(@giant.id.to_s)

      expect(@cart.count_of(@giant.id)).to eq(1)
    end

    it '.discount_eligible?()' do
      expect(@cart.discount_eligible?(@ogre.id, @discount1)).to eq(false)
      expect(@cart.discount_eligible?(@giant.id, @discount1)).to eq(false)
      expect(@cart2.discount_eligible?(@ogre.id, @discount1)).to eq(false)
      expect(@cart2.discount_eligible?(@monster.id, @discount1)).to eq(true)
    end

    it '.check_discount()' do
      expect(@cart.check_discount(@ogre.id)).to eq(false)
      expect(@cart.check_discount(@giant.id)).to eq(false)
      expect(@cart2.check_discount(@ogre.id)).to eq(false)
      expect(@cart2.check_discount(@monster.id)).to eq(true)
    end

    it '.best_discount()' do
      discount2 = @megan.discounts.create!(discount_percentage: 20, minimum_quantity: 10, description: '20% off when you buy 10 or more items')
      expect(@cart.best_discount(@ogre.id)).to eq(0.0)
      expect(@cart2.best_discount(@monster.id)).to eq(0.10)
    end

    it '.subtotal()' do
      expect(@cart2.subtotal_of(@monster.id)).to eq(45.0)
    end

    it 'adjusts grand total when a discount is applied' do
      cart3 = Cart.new({
        @ogre.id.to_s => 5,
        @monster.id.to_s => 10
        })

      expect(cart3.grand_total).to eq(180.0)
    end

  end
end
