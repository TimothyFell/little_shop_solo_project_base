require 'rails_helper'

RSpec.describe 'Show Password Link' do

  before(:each) do
    @password = 'Anything1!'
  end

  describe 'On the registration page' do

    it 'it shows the user what they typed into the password field' do
      skip("I NEED CAPYBARA-WEBKIT")

      visit register_path

      fill_in :user_password, with: @password

      expect(find('#user_password')['type']).to eq('password')
      
      click_on 'Show'

      expect(find('#user_password')['type']).to eq('text')
    end

  end

end
