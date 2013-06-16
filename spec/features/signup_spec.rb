require 'spec_helper'

describe 'new user creates and edits account' do
  def signup_user
    visit '/signup'
    fill_in "full_name", with: 'Maya Angelou'
    fill_in "email", with: 'poetry@poetry.com'
    fill_in "display_name", with: 'poet'
    fill_in "password", with: 'poet'
    fill_in "password_confirmation", with: 'poet'
    click_button "Sign Up"
  end

  describe 'registering a new account' do

    context 'when new customer signs up for an account' do
      it 'creates a new customer and new user account' do
        signup_user
        expect(page).to have_content "Welcome, Maya Angelou"
        expect(Customer.find_by_email("poetry@poetry.com")).to_not be nil
        expect(User.find_by_display_name("poet")).to_not be nil
        expect(current_path).to eq root_path
      end
    end

    context 'when returning customer signs up for an account' do
      it 'creates a User and associates it with customer on file' do
        Customer.create(email: "poetry@poetry.com", full_name: 'Maya Angelou')
        signup_user
        expect(page).to have_content "Welcome, Maya Angelou"
        expect(Customer.find_all_by_email("poetry@poetry.com").count).to be 1
        user = User.find_by_display_name("poet")
        expect(user).to_not be nil
        expect(user.customer.full_name).to eq 'Maya Angelou'
        expect(current_path).to eq root_path
      end
    end

    context 'when existing user tries to sign up again with same email' do
      it 'returns an error message' do
        signup_user
        visit '/signup'
        fill_in "full_name", with: 'IMPOSTER'
        fill_in "email", with: 'poetry@poetry.com'
        fill_in "display_name", with: 'poet'
        fill_in "password", with: 'poet'
        fill_in "password_confirmation", with: 'poet'
        click_button "Sign Up"
        expect(page).to have_content "Email already exists"
        expect(current_path).to eq '/signup'
      end
    end
  end
#######
  describe 'signing in and out of account' do
    before(:each) do
      signup_user
    end

    it 'allows them to log out of their account' do
      visit login_path
      fill_in "Email", with: 'poetry@poetry.com'
      fill_in "Password", with: "poet"
      click_button "Login"
      expect(current_path).to eq root_path
      click_link_or_button "Logout"
      expect(current_path).to eq root_path
      expect(page).to have_content "Logged out!"
    end

    it 'rejects incorrect login info on signin' do
      visit login_path
      fill_in "Email", with: 'poetry@poetry.com'
      fill_in "Password", with: "whatsmypassword"
      click_button "Login"
      expect(current_path).to eq login_path
      expect(page).to have_content 'invalid'
    end
  end

  it 'edits the account with valid input' do
    signup_user
    visit login_path
    fill_in "Email", with: 'poetry@poetry.com'
    fill_in "Password", with: "poet"
    click_button "Login"
    visit profile_path
    fill_in "display_name", with: 'Maya'

    click_button "Update"
    expect(current_path).to eq profile_path
    expect(page).to have_content "updated account"
  end
end
