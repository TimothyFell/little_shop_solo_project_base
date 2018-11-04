require 'factory_bot_rails'

include FactoryBot::Syntax::Methods

OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

# def quick_user(role = 0)
#   types = { 0 => "user", 1 => 'merch', 2 => 'admin' }
#   type  = types[role]
#   last  = User.last
#   last ? last = last.id : last = 0
#   id    = (last + 1).to_s
#   hash = Hash.new
#   hash[:email]    = type + id
#   hash[:password] = type + id
#   hash[:name]     = type + id
#   hash[:address]  = "Address" + id
#   hash[:city]     = "City"    + id
#   hash[:state]    = "State"   + id
#   hash[:zip]      = id.to_i * 100
#   hash[:role]     = role
#   hash[:active]   = 1
#   return hash
# end
#
# def main_user_set
#   main_user = quick_user(0)
#   main_user[:email]    = 'user'
#   main_user[:password] = 'user'
#   @user = User.create(main_user)
#
#   main_merch = quick_user(1)
#   main_merch[:email]    = 'merch'
#   main_merch[:password] = 'merch'
#   @merch = User.create(main_merch)
#
#   main_admin = quick_user(2)
#   main_admin[:email]    = 'admin'
#   main_admin[:password] = 'admin'
#   @admin = User.create(main_admin)
# end

admin = create(:admin, email:"admin@admin.com", password:"Administrator1!")
user = create(:user, email:"user@user.com", password:"ActiveUser1!")
merchant_1 = create(:merchant, email:"merchant@merchant.com", password:"Merchant1!")

merchant_2, merchant_3, merchant_4 = create_list(:merchant, 3)

item_1 = create(:item, user: merchant_1)
item_2 = create(:item, user: merchant_2)
item_3 = create(:item, user: merchant_3)
item_4 = create(:item, user: merchant_4)
create_list(:item, 10, user: merchant_1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_4, price: 4, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_3, price: 3, quantity: 1)

order = create(:completed_order, user: user)
create(:fulfilled_order_item, order: order, item: item_1, price: 1, quantity: 1)
create(:fulfilled_order_item, order: order, item: item_2, price: 2, quantity: 1)
