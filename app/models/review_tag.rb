# frozen_string_literal: true

# 中間ケーブル
class ReviewTag < ApplicationRecord
  belongs_to :review
  belongs_to :tag
end
