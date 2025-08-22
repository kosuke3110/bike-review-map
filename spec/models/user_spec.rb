# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it '名前とメールアドレスがあれば有効' do
    user = build(:user)
    expect(user).to be_valid
  end

  it '名前がなければ無効' do
    user = build(:user, name: nil)
    expect(user).not_to be_valid
  end
end
