require 'rails_helper'

RSpec.describe 'Merchant Coupon Codes' do
  describe 'as a merchant' do
    before(:each) do
      @merchant = create(:merchant, email:'merch@merch.com',password:'Merchant1!')
      visit login_path
      within('.container form') do
        fill_in 'Email', with:@merchant.email
        fill_in 'Password', with:@merchant.password
        click_on('Log in')
      end
    end

    it 'Can create percentage coupon code' do
      visit dashboard_path

      click_on('New Coupon')

      expect(current_path).to eq(new_dashboard_coupon_code_path)
    end

    it 'Can create dollars_off coupon code' do
      visit dashboard_path
      click_on('New Coupon')

      select 'Percentage', from: 'Coupon type'
      fill_in 'Value', with: 15
      fill_in 'Minimum Order Amount', with:20
      click_on('Create Coupon code')

      expect(current_path).to eq(dashboard_path)
    end

    it 'can see coupons created on dashboard' do
      visit dashboard_path
      click_on('New Coupon')

      select 'Percentage', from: 'Coupon type'
      fill_in 'Value', with: 15.25
      fill_in 'Minimum Order Amount', with:20.25
      click_on('Create Coupon code')

      expect(page).to have_content('Coupon Code')
      expect(page).to have_content('Value')
      expect(page).to have_content('Order Minimum')
      # Don't know the code since it is random
      expect(page).to have_content('15.25% off')
      expect(page).to have_content('Orders Above: $20.25')
    end

    describe 'coupon creation should fail if' do
      it 'if the coupon type is dollars off and the value is larger than the minimum order' do
        visit dashboard_path
        click_on('New Coupon')

        select 'Dollars Off', from: 'Coupon type'
        fill_in 'Value', with: 35.5
        fill_in 'Minimum Order Amount', with:20.25
        click_on('Create Coupon code')

        expect(current_path).to eq(new_dashboard_coupon_code_path)
        expect(page).to have_content('The discount amount you entered was larger than the minimum order amount. Please make the minimum order amount is larger than the coupon value.')
      end
    end


  end

  describe 'as a user' do
    before(:each) do
      @code = SecureRandom.uuid
      @merchant = create(:merchant)
      @user = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      @item_1, @item_2, @item_3 = create_list(:item, 3, user: @merchant)
      visit item_path(@item_1)
      click_button("Add to Cart")
      visit item_path(@item_2)
      click_button("Add to Cart")
      click_button("Add to Cart")
      visit item_path(@item_3)
      click_button("Add to Cart")
      click_button("Add to Cart")
      click_button("Add to Cart")
      visit carts_path
    end

    it 'I can use a coupon code on an order' do
      coupon = @merchant.coupon_codes.create({code: @code, value: 15, minimum_order: 20, coupon_type: 'percentage'})

      fill_in 'Enter Coupon', with: coupon.code
      click_on('Apply Coupon')

      expect(page).to have_content('Discount: 15.0%')
    end

    xit 'if my order isnt big enough coupon fails' do
      coupon = @merchant.coupon_codes.create({code: @code, value: 15, minimum_order: 20000000, coupon_type: 'percentage'})

      fill_in 'Enter Coupon', with: coupon.code
      click_on('Apply Coupon')

      expect(page).to have_conten("You order wasn't large enough to use this coupon.")
    end


  end

end
