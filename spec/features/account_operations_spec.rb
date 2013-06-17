require 'spec_helper'

describe 'user accounts' do
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
