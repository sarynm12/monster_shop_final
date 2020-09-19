require 'rails_helper'

RSpec.describe 'Merchant Discount Index Page' do
  describe 'As a merchant' do
    before :each do
      @merchant_1 = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @merchant_2 = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @m_user = @merchant_1.users.create(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword')
      @ogre = @merchant_1.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20.25, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
      @giant = @merchant_1.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
      @hippo = @merchant_2.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 1 )
      @order_1 = @m_user.orders.create!(status: "pending")
      @order_2 = @m_user.orders.create!(status: "pending")
      @order_3 = @m_user.orders.create!(status: "pending")
      @order_item_1 = @order_1.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: false)
      @order_item_2 = @order_2.order_items.create!(item: @hippo, price: @hippo.price, quantity: 2, fulfilled: true)
      @order_item_3 = @order_2.order_items.create!(item: @ogre, price: @ogre.price, quantity: 2, fulfilled: false)
      @order_item_4 = @order_3.order_items.create!(item: @giant, price: @giant.price, quantity: 2, fulfilled: false)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'can create a new discount' do
      visit '/merchant/discounts'
      click_link 'Create New Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('Discount Percentage:')
      expect(page).to have_content('Minimum Quantity:')
      expect(page).to have_content('Description:')

      fill_in :discount_percentage, with: 10
      fill_in :minimum_quantity, with: 5
      fill_in :description, with: '10% off when you buy 5 or more items'

      click_on 'Create Discount'
      require "pry"; binding.pry
      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content("Your new discount has been added")
    end

    it 'will display a flash message if there are missing fields for a new discount' do
      visit '/merchant/discounts'
      click_link 'Create New Discount'

      expect(current_path).to eq('/merchant/discounts/new')
      expect(page).to have_content('Discount Percentage:')
      expect(page).to have_content('Minimum Quantity:')
      expect(page).to have_content('Description:')

      fill_in :discount_percentage, with: 10
      fill_in :minimum_quantity, with: 5
      fill_in :description, with: ''

      click_on 'Create Discount'
      expect(page).to have_content("Please fill out all 3 fields")
      expect(current_path).to eq('/merchant/discounts/new')
    end

  end
end
