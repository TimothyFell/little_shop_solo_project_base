require 'rails_helper'

RSpec.describe 'Registration and Session Management' do
  describe 'Registration' do
    it 'anonymous visitor registers properly' do
      email = 'fred@gmail.com'
      password = 'Test1234!'
      visit register_path

      expect(current_path).to eq(register_path)
      fill_in :user_email, with: email
      fill_in :user_password, with: password
      fill_in :user_password_confirmation, with: password
      fill_in :user_name, with: 'Name'
      fill_in :user_address, with: 'Address'
      fill_in :user_city, with: 'City'
      fill_in :user_state, with: 'State'
      fill_in :user_zip, with: 'Zip'
      click_button 'Create User'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content(email)
      expect(page).to_not have_content(password)
    end
    describe 'anonymous visitor fails registration' do
      scenario 'because form was blank' do
        visit new_user_path
        click_button 'Create User'

        expect(current_path).to eq(users_path)
        expect(page).to have_content('9 errors prohibited this user from being saved')
      end

      it 'because password confirmation was wrong' do
        email = 'fred@gmail.com'
        password = 'Test1234!'
        visit register_path

        expect(current_path).to eq(register_path)
        fill_in :user_email, with: email
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: 'something else'
        fill_in :user_name, with: 'Name'
        fill_in :user_address, with: 'Address'
        fill_in :user_city, with: 'City'
        fill_in :user_state, with: 'State'
        fill_in :user_zip, with: 'Zip'
        click_button 'Create User'

        expect(current_path).to eq(users_path)
        expect(page).to have_content("Password confirmation doesn't match Password")
      end

      it 'because user already existed' do
        email = 'fred@gmail.com'
        password = '9876Test!'
        create(:user, email: email)
        visit new_user_path
        fill_in :user_email, with: email
        fill_in :user_password, with: password
        fill_in :user_password_confirmation, with: password
        fill_in :user_name, with: 'Name'
        fill_in :user_address, with: 'Address'
        fill_in :user_city, with: 'City'
        fill_in :user_state, with: 'State'
        fill_in :user_zip, with: 'Zip'
        click_button 'Create User'

        expect(current_path).to eq(users_path)
        expect(page).to have_content('Email has already been taken')
      end

      describe 'Because the password' do

        before(:each) do
          @email = 'bob@email.com'
        end

        scenario 'does not contain a lowercase letter' do
          visit register_path
          password = 'PASSWORD1!'

          fill_in :user_email, with: @email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          fill_in :user_name, with: 'Name'
          fill_in :user_address, with: 'Address'
          fill_in :user_city, with: 'City'
          fill_in :user_state, with: 'State'
          fill_in :user_zip, with: 'Zip'
          click_button 'Create User'

          expect(page).to have_content('Password is invalid')
        end
        scenario 'does not contain an uppercase letter' do
          visit register_path
          password = 'password1!'

          fill_in :user_email, with: @email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          fill_in :user_name, with: 'Name'
          fill_in :user_address, with: 'Address'
          fill_in :user_city, with: 'City'
          fill_in :user_state, with: 'State'
          fill_in :user_zip, with: 'Zip'
          click_button 'Create User'

          expect(page).to have_content('Password is invalid')
        end
        scenario 'does not contain a number' do
          visit register_path
          password = 'Password!'

          fill_in :user_email, with: @email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          fill_in :user_name, with: 'Name'
          fill_in :user_address, with: 'Address'
          fill_in :user_city, with: 'City'
          fill_in :user_state, with: 'State'
          fill_in :user_zip, with: 'Zip'
          click_button 'Create User'

          expect(page).to have_content('Password is invalid')
        end
        scenario 'does not contain a symbol' do
          visit register_path
          password = 'Password1'

          fill_in :user_email, with: @email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          fill_in :user_name, with: 'Name'
          fill_in :user_address, with: 'Address'
          fill_in :user_city, with: 'City'
          fill_in :user_state, with: 'State'
          fill_in :user_zip, with: 'Zip'
          click_button 'Create User'

          expect(page).to have_content('Password is invalid')
        end
        scenario 'is not longer than 8 characters' do
          visit register_path
          password = 'Pass1!'

          fill_in :user_email, with: @email
          fill_in :user_password, with: password
          fill_in :user_password_confirmation, with: password
          fill_in :user_name, with: 'Name'
          fill_in :user_address, with: 'Address'
          fill_in :user_city, with: 'City'
          fill_in :user_state, with: 'State'
          fill_in :user_zip, with: 'Zip'
          click_button 'Create User'

          expect(page).to have_content('Password is invalid')
        end

      end
    end
  end

  describe 'Login workflow' do
    before(:each) do
      @email = 'drpepper@gmail.com'
      @password = 'Awesomesoda1!'
      @user = create(:user, email: @email, password: @password)
    end
    it 'should succeed if credentials are correct' do
      visit root_path
      click_link 'Log in'

      fill_in :email, with: @email
      fill_in :password, with: @password
      click_button 'Log in'

      expect(current_path).to eq(profile_path)
      expect(page).to have_content("Logged in as #{@user.name}")
      expect(page).to have_content(@email)
    end

    it 'should redirect with a message if already logged in' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit login_path
      expect(current_path).to eq(profile_path)
      expect(page).to have_content('You are already logged in')
    end

    describe 'logging in did not succeed' do
      scenario 'because credentials are incorrect' do
        visit root_path
        click_link 'Log in'

        fill_in :email, with: @username
        fill_in :password, with: 'bad password'
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_button("Log in")
        expect(page).to_not have_content(@email)
      end

      scenario 'because credentials are empty' do
        visit login_path
        click_button 'Log in'

        expect(current_path).to eq(login_path)
        expect(page).to have_button("Log in")
        expect(page).to_not have_content(@email)
      end

    end
  end

  describe 'Logout workflow' do
    before(:each) do
      @email = 'drpepper@gmail.com'
      @password = 'Awesomesoda1!'
      @user = create(:user, email: @email, password: @password)
    end
    it 'should succeed if credentials are correct' do
      visit login_path
      fill_in :email, with: @email
      fill_in :password, with: @password
      click_button 'Log in'

      expect(current_path).to eq(profile_path)

      click_link 'Log out'

      expect(current_path).to eq(root_path)
      expect(page).to_not have_content("Log out")
      expect(page).to have_content("Log in")
      expect(page).to have_content("You are logged out")
    end
  end
end
