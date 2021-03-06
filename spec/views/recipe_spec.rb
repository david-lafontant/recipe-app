require 'rails_helper'

RSpec.describe 'User index page', type: :feature do
  describe 'Recipe' do
    before(:each) do
      @user = User.create!(name: 'Esther Alice', password: '123456', email: 'estherAlice@gmail.com',
                           confirmed_at: Time.now)
      @recipe = Recipe.create! user_id: @user.id, name: 'New recipe name', preparation_time: 20, cooking_time: 40,
                               description: 'Recipe description', public: true
      visit '/users/sign_in'
      fill_in 'Email', with: 'estherAlice@gmail.com'
      fill_in 'Password', with: '123456'
      click_button 'Log in'
    end

    scenario 'Public recipe is displayed on public_recipes page' do
      visit '/public_recipes'
      expect(page).to have_content('New recipe name')
    end

    scenario 'USers can view their own recipes and see delete button' do
      visit '/users/1/recipes'
      expect(page).to have_content('New recipe name')
      expect(page).to have_content('REMOVE')
    end

    scenario 'Users can delete their recipes' do
      visit '/users/1/recipes'
      expect(page).to have_content('New recipe name')
      click_button 'REMOVE'
      expect(page).should have_no_content('New recipe name')
    end

    scenario 'Users can create a new recipe' do
      visit '/users/1/recipes/new'
      expect(page).to have_content('Create a new recipe')
      fill_in 'Name', with: 'New recipe'
      fill_in 'Description', with: 'Description'
      click_button 'Create Recipe'

      expect(page).to have_content('New recipe')
    end
  end
end
