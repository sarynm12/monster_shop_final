require 'rails_helper'

RSpec.describe 'Merchant Discount Edit Page' do
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
      @discount1 = @merchant_1.discounts.create!(discount_percentage: 10, minimum_quantity: 5, description: '10% off when you buy 5 or more items')
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@m_user)
    end

    it 'has a link to edit a discount' do

      visit "/merchant/discounts"

      expect(page).to have_link('Edit Discount')
    end

    it 'can update an existing discount' do

      visit "/merchant/discounts/edit/#{@discount1.id}"

      fill_in :discount_percentage, with: 8
      fill_in :minimum_quantity, with: 4
      fill_in :description, with: '8% off when you buy 4 items or more'
      click_on 'Update Discount'

      expect(current_path).to eq('/merchant/discounts')
      expect(page).to have_content(8)
      expect(page).to have_content(4)
      expect(page).to have_content('8% off when you buy 4 items or more')
    end

    it 'displays a flash message if an edit field is left empty' do

      visit "/merchant/discounts/edit/#{@discount1.id}"

      fill_in :discount_percentage, with: 8
      fill_in :minimum_quantity, with: ''
      fill_in :description, with: '8% off when you buy 4 items or more'
      click_on 'Update Discount'

      expect(page).to have_content("Minimum quantity can't be blank and Minimum quantity is not a number")
      expect(current_path).to eq("/merchant/discounts/edit/#{@discount1.id}")
    end

    it 'displays a flash message if appropriate fields are not a number' do

      visit "/merchant/discounts/edit/#{@discount1.id}"

      fill_in :discount_percentage, with: 8
      fill_in :minimum_quantity, with: 'hi'
      fill_in :description, with: '8% off when you buy 4 items or more'
      click_on 'Update Discount'

      expect(page).to have_content("Minimum quantity is not a number")
      expect(current_path).to eq("/merchant/discounts/edit/#{@discount1.id}")
    end

  end
end
