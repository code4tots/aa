require 'spec_helper'

feature 'the signup process' do
  
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content 'Sign up!'
  end
  
  feature 'signing up a user' do
    
    before :each do
      visit new_user_url
      fill_in 'user[username]', with: 'some_username'
      fill_in 'user[password]', with: 'some_password'
      click_on 'sign up'
    end
    
    scenario 'shows username on the homepage' do
      expect(page).to have_content 'some_username'
    end
  end
end

feature 'logging in' do
  before :each do
    # Create an account to log into
    visit new_user_url
    fill_in 'user[username]', with: 'some_username'
    fill_in 'user[password]', with: 'some_password'
    click_on 'sign up'
  end
  
  scenario 'shows username on the homepage after login' do
    visit new_session_url
    fill_in 'user[username]', with: 'some_username'
    fill_in 'user[password]', with: 'some_password'
    click_button 'sign in'
    expect(page).to have_content 'some_username'
  end
end

feature 'logging out' do
  scenario 'begins with logged out state' do
    visit new_session_url
    expect(page).to have_content 'sign in'
  end
  
  scenario "doesn't show username on the homepage after logout" do

    visit new_user_url
    fill_in 'user[username]', with: 'some_username'
    fill_in 'user[password]', with: 'some_password'
    click_on 'sign up'

    visit new_session_url
    fill_in 'user[username]', with: 'some_username'
    fill_in 'user[password]', with: 'some_password'
    click_button 'sign in'

    # save_and_open_page
    click_link 'sign out'
    expect(page).to have_no_content 'some_username'
  end
end
