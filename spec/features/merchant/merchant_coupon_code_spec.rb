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

    xit 'Can create percentage coupon code' do
      visit dashboard_path

      click_on('New Coupon')

      expect(current_path).to eq(new_dashboard_coupon_code_path)
    end

    xit 'Can create dollars_off coupon code' do
      visit dashboard_path
      click_on('New Coupon')

      select 'Percentage', from: 'Coupon type'
      fill_in 'Value', with: 15
      fill_in 'Minimum order', with:20
      click_on('Create Coupon code')

      expect(current_path).to eq(dashboard_path)
    end

    xit 'can see coupons created on dashboard' do
      visit dashboard_path
      click_on('New Coupon')

      select 'Percentage', from: 'Coupon type'
      fill_in 'Value', with: 15.25
      fill_in 'Minimum order', with:20.25
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
        fill_in 'Minimum order', with:20.25
        click_on('Create Coupon code')

        expect(current_path).to eq(new_dashboard_coupon_code_path)
        expect(page).to have_content('The discount amount you entered was larger than the minimum order value. Please make the minimum order value larger than the coupon value.')
      end
    end


  end

  describe 'as a user' do

  end

end
