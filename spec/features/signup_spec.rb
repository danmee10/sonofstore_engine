require 'spec_helper'

describe 'new user creates and edits account' do
  def signup_user
    visit '/signup'
    fill_in "user_customer_full_name", with: 'Maya Angelou'
    fill_in "user_customer_email", with: 'poetry@poetry.com'
    fill_in "user_display_name", with: 'poet'
    fill_in "user_password", with: 'poet'
    fill_in "user_password_confirmation", with: 'poet'
    click_button "Create User"
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
        fill_in "user_customer_full_name", with: 'IMPOSTER'
        fill_in "user_customer_email", with: 'poetry@poetry.com'
        fill_in "user_display_name", with: 'poet'
        fill_in "user_password", with: 'poet'
        fill_in "user_password_confirmation", with: 'poet'
        click_button "Create User"
        expect(page).to have_content "Account already exists with that email"
        expect(current_path).to eq '/signup'
      end
    end

    describe "form-level validations" do
      context "user enters invalid credentials" do
        it "triggers appropriate flash message if user enters invalid email" do
          visit '/signup'
          fill_in "user_customer_full_name", with: 'Maya Angelou'
          fill_in "user_customer_email", with: 'poetry.com'
          fill_in "user_display_name", with: 'poet'
          fill_in "user_password", with: 'poet'
          fill_in "user_password_confirmation", with: 'poet'
          click_button "Create User"
          expect(page).to have_content "Please enter a vaild email address"
        end

        it "triggers appropriate flash message if user fails to fill required field" do
          visit '/signup'
          fill_in "user_customer_email", with: 'poetry@poetry.com'
          fill_in "user_display_name", with: 'poet'
          fill_in "user_password", with: 'poet'
          fill_in "user_password_confirmation", with: 'poet'
          click_button "Create User"
          expect(page).to have_content "Please fill in all required fields"
        end

        it "triggers appropriate flash message if password doesn't match confirmation" do
          visit '/signup'
          fill_in "user_customer_full_name", with: 'Maya Angelou'
          fill_in "user_customer_email", with: 'poetry@poetry.com'
          fill_in "user_display_name", with: 'poet'
          fill_in "user_password", with: 'poet'
          fill_in "user_password_confirmation", with: 'gorrilla'
          click_button "Create User"
          expect(page).to have_content "Password must match confirmation"
        end
        it "triggers appropriate flash message if user enters invalid display_name" do
          visit '/signup'
          fill_in "user_customer_full_name", with: 'Maya Angelou'
          fill_in "user_customer_email", with: 'poetry@poetry.com'
          fill_in "user_display_name", with: 't'
          fill_in "user_password", with: 'poet'
          fill_in "user_password_confirmation", with: 'poet'
          click_button "Create User"
          expect(page).to have_content "Display name must be between 2 and 32 characters"
        end
      end
    end
  end
end
