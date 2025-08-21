# frozen_string_literal: true

class AddShopNameToReviews < ActiveRecord::Migration[7.1]
  def change
    add_column :reviews, :shop_name, :string
  end
end
