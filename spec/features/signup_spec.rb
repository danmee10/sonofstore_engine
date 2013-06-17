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

    describe "form-level validations" do
      context "user enters invalid credentials" do
        it "triggers appropriate flash message if user enters invalid email" do
          visit '/signup'
          fill_in "full_name", with: 'Maya Angelou'
          fill_in "email", with: 'poetry@poetry.com'
          fill_in "display_name", with: 'poet'
          fill_in "password", with: 'poet'
          fill_in "password_confirmation", with: 'poet'
          click_button "Sign Up"
        end
        it "triggers appropriate flash message if user enters invalid full_name"
        it "triggers appropriate flash message if user enters invalid password"
        it "triggers appropriate flash message if user enters invalid display_name"
      end
    end
  end
end
