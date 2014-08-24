require 'spec_helper'

feature 'the signup process' do
  
  scenario 'has a new user page' do
    visit new_user_url
    expect(page).to have_content 'sign up'
  end
  
  feature 'signing up a user' do
    
    before :each do
      visit new_user_url
      fill_in 'username', with: 'some_username'
      fill_in 'password', with: 'some_password'
      click_on 'sign up'
    end
    
    scenario 'shows username on the homepage' do
      expect(page).to have_content 'some_username'
    end
  end
end

feature 'logging in' do
  before :each do
    visit new_session_url
    fill_in 'username', with: 'some_username'
    fill_in 'password', with: 'some_password'
    click_on 'sign in'
  end
  
  scenario 'shows username on the homepage after login' do
    expect(page).to have_content 'some_username'
  end
end

feature 'logging out' do
  before :each do
    visit new_session_url
  end
  
  scenario 'begins with logged out state' do
    expect(page).to have_content 'sign in'
  end
  
  scenario "doesn't show username on the homepage after logout" do
    fill_in 'username', with: 'some_username'
    fill_in 'password', with: 'some_password'
    click_on 'sign in'
    click_on 'sign out'
    expect(page).to have_no_content 'some_username'
  end
  
end