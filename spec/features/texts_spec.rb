require 'rails_helper'

feature 'Texts' do
  include_context 'shared_lets'

  # We use helper lets from shared context, where:
  # plain_example is a plain text,
  # proper_response is an encrypted text,
  # shift_num is a number 4 (shift_range)
  describe 'large screens', js: true do
    scenario 'It properly encrypts the text' do
      visit root_path
      fill_in 'source-text', with: plain_example
      fill_in 'rot-input', with: shift_num
      click_button 'encrypt-button'

      assert_equal proper_response, page.find('#result-text').value
    end

    scenario 'It properly decrypts the text' do
      visit root_path
      fill_in 'source-text', with: proper_response
      fill_in 'rot-input', with: shift_num
      click_button 'decrypt-button'
      assert_equal plain_example, page.find('#result-text').value
    end
  end

  describe 'small screens', js: true do
    scenario 'It properly encrypts the text' do
      visit root_path
      resize_window_width(300, 600)
      fill_in 'source-text', with: plain_example
      fill_in 'rot-input', with: shift_num
      page.find('#sm-encrypt-button').click

      assert_equal proper_response, page.find('#result-text').value
    end

    scenario 'It properly decrypts the text' do
      # The window is already resized
      visit root_path
      fill_in 'source-text', with: proper_response
      fill_in 'rot-input', with: shift_num
      page.find('#sm-decrypt-button').click

      assert_equal plain_example, page.find('#result-text').value
    end
  end
end
