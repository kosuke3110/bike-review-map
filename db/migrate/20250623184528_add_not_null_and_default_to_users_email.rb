# frozen_string_literal: true

class AddNotNullAndDefaultToUsersEmail < ActiveRecord::Migration[7.1]
  def change
    change_column_default :users, :email, ''
    change_column_null :users, :email, false
  end
end
