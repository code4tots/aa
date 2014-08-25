require 'spec_helper'

feature 'CRUD goals' do

  # Should have a users to sign into.
  before :each do
    visit new_user_url
    fill_in 'user[username]', with: 'user1'
    fill_in 'user[password]', with: 'password1'
    click_button 'sign up'
    click_link 'sign out'
    
    visit new_user_url
    fill_in 'user[username]', with: 'user2'
    fill_in 'user[password]', with: 'password2'
    click_button 'sign up'
    click_link 'sign out'
  end

  scenario 'should have a goals page' do
    visit goals_url
  end

  context 'while not signed in' do
    scenario 'should NOT have a new goal button' do
      visit goals_url
      expect(page).to have_no_content 'new goal'
    end
  end

  context 'while signed in' do
    before :each do
      visit new_session_url
      fill_in 'user[username]', with: 'user1'
      fill_in 'user[password]', with: 'password1'
      click_button 'sign in'
    end

    scenario 'should have a new goal button' do
      visit goals_url
      expect(page).to have_content 'new goal'
    end
  end

  feature 'with goals' do
    # create some goals to play with
    before :each do
      visit new_session_url
      fill_in 'user[username]', with: 'user1'
      fill_in 'user[password]', with: 'password1'
      click_button 'sign in'
      
      visit new_goal_url
      fill_in 'goal[name]', with: 'goal1'
      # fill_in 'goal[access]', with: 'public'
      select 'public', from: 'goal[access]'
      fill_in 'goal[description]', with: 'public goal1 by user 1'
      click_button 'create goal'
      
      visit new_goal_url
      fill_in 'goal[name]', with: 'goal2'
      # fill_in 'goal[access]', with: 'private'
      select 'private', from: 'goal[access]'
      fill_in 'goal[description]', with: 'private goal2 by user 1'
      click_button 'create goal'
    end
    
    feature 'as user1' do
      scenario 'should be able to see all the goals' do
        visit goals_url
        expect(page).to have_content 'goal1'
        expect(page).to have_content 'goal2'
      end
    end
    
    feature 'as anonymous user' do
      before :each do
        click_link 'sign out'
      end
      
      scenario 'should only be able to see public goals' do
        visit goals_url
        expect(page).to have_content 'goal1'
        expect(page).to have_no_content 'goal2'
      end
    end
  end
end

