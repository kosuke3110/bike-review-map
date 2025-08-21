# frozen_string_literal: true

class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.string :shop_place_id, null: false
      t.integer :rating_overall, null: false
      t.integer :rating_skill, null: false
      t.integer :rating_service, null: false
      t.integer :rating_price, null: false
      t.text :comment

      t.timestamps
    end
  end
end
