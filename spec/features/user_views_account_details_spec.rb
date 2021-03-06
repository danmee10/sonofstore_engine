require 'spec_helper'

describe 'user account detail view' do
  context 'when the user is logged in' do
    before(:each) do
      customer = FactoryGirl.create(:customer)
      @user = FactoryGirl.create(:user, customer_id: customer.id)
      visit '/login'
      fill_in 'sessions_email', with: 'dboone54@yahoo.com'
      fill_in 'sessions_password', with: 'password'
      click_button 'Login'
    end

    it 'display the main page of their account details' do
      visit 'profile'
      expect(page).to have_content("Account")
    end

    it 'cannot update their profile with incorrect information' do
      visit 'profile'
      click_link_or_button 'Edit Account'
      fill_in 'password', with: 't'
      click_button 'Update'
      expect(page).to have_content("not match")
    end

    context 'when they click the link to their order history page' do
      it 'takes them to their order history page' do
        visit 'profile'
        click_link "Order History"
        expect(page).to have_content("Order History")
      end
    end

    context 'when they click on a specific order link' do
      it 'takes them to a view of their specific order' do
        pending
        # order = FactoryGirl.create(:order, user: @user)
        # visit 'profile'
        # click_link "Order History"
        # save_and_open_page
        # click_link "Order ##{order.id}"
        # expect(page).to have_content("Quantity")
      end
    end
  end
end
