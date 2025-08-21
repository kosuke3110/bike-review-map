# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ショップ検索', type: :system do
  before do
    driven_by(:rack_test) # JS不要
  end

  it '検索結果を表示できる' do
    visit search_shops_path
    fill_in 'address', with: '東京都'
    click_button '検索'
    expect(page).to have_content('検索結果')
  end
end
