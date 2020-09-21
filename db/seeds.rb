# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
m_user = megan.users.create!(name: 'Megan', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'megan@example.com', password: 'securepassword', role: 1)
b_user = brian.users.create!(name: 'Saryn', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218, email: 'saryn@example.com', password: 'testpassword')
megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 5 )
megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', active: true, inventory: 3 )
elle = User.create!(name: 'Elle', address: '246 Waikiki Rd.', city: 'Seattle', state: 'WA', zip: 99208, email: 'elle@example.com', password: 'thispasswordsucks')
hunter = User.create!(name: 'Hunter', address: '123 Clarkson Rd.', city: 'Denver', state: 'CO', zip: 80122, email: 'hunter@example.com', password: 'whatshappening')
megan.discounts.create!(discount_percentage: 10, minimum_quantity: 5, description: '10% off when you buy 5 or more items')
megan.discounts.create!(discount_percentage: 20, minimum_quantity: 15, description: '20% off when you buy 15 or more items')
brian.discounts.create!(discount_percentage: 20, minimum_quantity: 10, description: '20% off when you buy 10 or more items')
