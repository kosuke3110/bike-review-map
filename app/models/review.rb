# frozen_string_literal: true

# 自転車店レビュー
class Review < ApplicationRecord
  belongs_to :user
  has_many :review_tags, dependent: :destroy
  has_many :tags, through: :review_tags
  # validates :shop_place_id, :comment, presence: true
  validates :rating_overall, :rating_skill, :rating_service, :rating_price,
            presence: true,
            inclusion: { in: 1..5 }
end
